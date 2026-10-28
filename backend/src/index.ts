// ─── Env ─────────────────────────────────────────────────────────────────────

export interface Env {
  GEMINI_API_KEY: string;
  MOCK_MODE?: string;
}

// ─── Constants ───────────────────────────────────────────────────────────────

const GEMINI_MODEL = 'gemini-3.1-flash-lite';
const GEMINI_API_URL =
  `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;
const GEMINI_TIMEOUT_MS = 25_000;

const VALID_VERDICTS = new Set(['ABSOLVIDO', 'CULPADO', 'PARCIALMENTE CULPADO']);

/**
 * Origens permitidas a chamar este Worker.
 * Entradas `localhost` cobrem o Flutter Web durante desenvolvimento local.
 * Para restringir em produção, adicionar aqui a URL do Flutter Web em produção
 * e remover (ou manter) as entradas localhost conforme necessário.
 */
const ALLOWED_ORIGINS = [
  'http://localhost:5000',
  'http://localhost:8080',
  'http://localhost:3000',
  'http://localhost:4040',
];

// ─── Types ───────────────────────────────────────────────────────────────────

/**
 * Contrato de resposta alinhado ao VerdictModel.fromJson() do Flutter.
 * Qualquer alteração aqui deve ser acompanhada de alteração no modelo Dart.
 */
interface VerdictData {
  credibility: number;   // 0-100
  creativity: number;    // 0-100
  excuseLevel: number;   // 0-100
  verdict: string;       // 'ABSOLVIDO' | 'CULPADO' | 'PARCIALMENTE CULPADO'
  justification: string; // non-empty
  punishment: string;    // non-empty
}

type GeminiResult =
  | { ok: true; data: VerdictData }
  | { ok: false; status: number; message: string };

// ─── CORS ────────────────────────────────────────────────────────────────────

function getAllowedOrigin(origin: string | null): string {
  if (origin === null) return ALLOWED_ORIGINS[0]!;
  // Permite qualquer porta localhost durante desenvolvimento
  if (origin.startsWith('http://localhost:')) return origin;
  // Restringe a origens conhecidas
  return ALLOWED_ORIGINS.includes(origin) ? origin : ALLOWED_ORIGINS[0]!;
}

function corsHeaders(origin: string | null): Record<string, string> {
  return {
    'Access-Control-Allow-Origin': getAllowedOrigin(origin),
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };
}

// ─── Response helpers ────────────────────────────────────────────────────────

function jsonResponse(body: unknown, status: number, origin: string | null): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
      ...corsHeaders(origin),
    },
  });
}

function errorResponse(message: string, status: number, origin: string | null): Response {
  return jsonResponse({ error: message }, status, origin);
}

// ─── Validation ──────────────────────────────────────────────────────────────

function isValidScore(value: unknown): boolean {
  return (
    typeof value === 'number' &&
    !isNaN(value) &&
    isFinite(value) &&
    value >= 0 &&
    value <= 100
  );
}

/**
 * Valida defensivamente o JSON recebido do Gemini antes de devolvê-lo ao Flutter.
 * Falha explicitamente se qualquer campo estiver ausente ou inválido.
 */
function validateVerdict(data: unknown): data is VerdictData {
  if (typeof data !== 'object' || data === null) return false;
  const d = data as Record<string, unknown>;

  if (!isValidScore(d['credibility'])) return false;
  if (!isValidScore(d['creativity'])) return false;
  if (!isValidScore(d['excuseLevel'])) return false;
  if (typeof d['verdict'] !== 'string' || !VALID_VERDICTS.has(d['verdict'])) return false;
  if (typeof d['justification'] !== 'string' || d['justification'].trim() === '') return false;
  if (typeof d['punishment'] !== 'string' || d['punishment'].trim() === '') return false;

  return true;
}

// ─── Mock ────────────────────────────────────────────────────────────────────

const MOCK_VERDICT: VerdictData = {
  credibility: 42.5,
  creativity: 71.8,
  excuseLevel: 88.3,
  verdict: 'CULPADO',
  justification: 'Resposta simulada do tribunal.',
  punishment: 'Você foi condenado a revisar sua desculpa.',
};

// ─── Gemini ──────────────────────────────────────────────────────────────────

const VERDICT_SCHEMA = {
  type: 'object',
  properties: {
    credibility:   { type: 'number' },
    creativity:    { type: 'number' },
    excuseLevel:   { type: 'number' },
    verdict:       { type: 'string', enum: ['ABSOLVIDO', 'CULPADO', 'PARCIALMENTE CULPADO'] },
    justification: { type: 'string' },
    punishment:    { type: 'string' },
  },
  required: ['credibility', 'creativity', 'excuseLevel', 'verdict', 'justification', 'punishment'],
};

async function callGemini(
  apiKey: string,
  accusation: string,
  excuse: string,
): Promise<GeminiResult> {
  const prompt =
    'Você é o Juiz Supremo do Tribunal das Desculpas. ' +
    'Analise a acusação e a desculpa abaixo e emita um veredito rigoroso e criativo.\n\n' +
    `Acusação: ${accusation}\n` +
    `Desculpa: ${excuse}`;

  const requestBody = {
    contents: [{ parts: [{ text: prompt }] }],
    generationConfig: {
      responseMimeType: 'application/json',
      responseSchema: VERDICT_SCHEMA,
    },
  };

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), GEMINI_TIMEOUT_MS);

  let geminiResponse: Response;

  try {
    geminiResponse = await fetch(`${GEMINI_API_URL}?key=${apiKey}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(requestBody),
      signal: controller.signal,
    });
  } catch (err) {
    if (err instanceof Error && err.name === 'AbortError') {
      return { ok: false, status: 504, message: 'Request timed out' };
    }
    return { ok: false, status: 502, message: 'Upstream API error' };
  } finally {
    clearTimeout(timeoutId);
  }

  if (geminiResponse.status === 429) {
    return { ok: false, status: 429, message: 'Rate limit reached. Try again later.' };
  }

  if (!geminiResponse.ok) {
    return { ok: false, status: 502, message: 'Upstream API error' };
  }

  let rawJson: unknown;
  try {
    rawJson = await geminiResponse.json();
  } catch {
    return { ok: false, status: 502, message: 'Invalid response from AI' };
  }

  interface GeminiApiResponse {
    candidates?: Array<{
      content?: {
        parts?: Array<{
          text?: string;
        }>;
      };
    }>;
  }

  // O Gemini encapsula o Structured Output em candidates[0].content.parts[0].text
  // como uma string JSON que precisa ser parseada.
  const geminiData = rawJson as GeminiApiResponse | null;
  const text = geminiData?.candidates?.[0]?.content?.parts?.[0]?.text;

  if (typeof text !== 'string') {
    return { ok: false, status: 502, message: 'Invalid response from AI' };
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    return { ok: false, status: 502, message: 'Invalid response from AI' };
  }

  // Valida defensivamente antes de devolver — não corrige silenciosamente
  if (!validateVerdict(parsed)) {
    return { ok: false, status: 502, message: 'Invalid response from AI' };
  }

  return { ok: true, data: parsed };
}

// ─── Handler ─────────────────────────────────────────────────────────────────

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const origin = request.headers.get('Origin');

    try {
      // Preflight CORS
      if (request.method === 'OPTIONS') {
        return new Response(null, {
          status: 200,
          headers: corsHeaders(origin),
        });
      }

      const { pathname } = new URL(request.url);

      if (pathname !== '/judge') {
        return errorResponse('Not found', 404, origin);
      }

      if (request.method !== 'POST') {
        return errorResponse('Method not allowed', 405, origin);
      }

      const contentType = request.headers.get('Content-Type') ?? '';
      if (!contentType.includes('application/json')) {
        return errorResponse('Content-Type must be application/json', 415, origin);
      }

      let body: unknown;
      try {
        body = await request.json();
      } catch {
        return errorResponse('Invalid JSON body', 400, origin);
      }

      if (typeof body !== 'object' || body === null) {
        return errorResponse('Invalid JSON body', 400, origin);
      }

      const { accusation: rawAccusation, excuse: rawExcuse } =
        body as Record<string, unknown>;

      if (typeof rawAccusation !== 'string' || rawAccusation.trim() === '') {
        return errorResponse('accusation and excuse are required', 400, origin);
      }

      if (typeof rawExcuse !== 'string' || rawExcuse.trim() === '') {
        return errorResponse('accusation and excuse are required', 400, origin);
      }

      const accusation = rawAccusation.trim();
      const excuse = rawExcuse.trim();

      // MOCK_MODE: retorna JSON fixo sem chamar o Gemini
      if (env.MOCK_MODE === 'true') {
        return jsonResponse(MOCK_VERDICT, 200, origin);
      }

      const result = await callGemini(env.GEMINI_API_KEY, accusation, excuse);

      if (!result.ok) {
        return errorResponse(result.message, result.status, origin);
      }

      return jsonResponse(result.data, 200, origin);
    } catch {
      return errorResponse('Unexpected error', 500, origin);
    }
  },
} satisfies ExportedHandler<Env>;
