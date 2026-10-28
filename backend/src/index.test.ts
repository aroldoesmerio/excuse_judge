import { afterEach, describe, expect, it, vi } from 'vitest';
import worker, { type Env } from './index';

// ─── Helpers ─────────────────────────────────────────────────────────────────

const mockEnv: Env = {
  GEMINI_API_KEY: 'test-fake-key-never-used',
  MOCK_MODE: 'true',
};

const realGeminiEnv: Env = {
  GEMINI_API_KEY: 'test-fake-key-never-used',
  MOCK_MODE: 'false',
};

const JUDGE_URL = 'http://localhost/judge';
const JSON_HEADERS = { 'Content-Type': 'application/json' };
const LOCALHOST_ORIGIN = 'http://localhost:8080';

const VALID_BODY = JSON.stringify({
  accusation: 'Não entregou o relatório no prazo',
  excuse: 'O cachorro comeu meu notebook',
});

// ─── 1. Método inválido ───────────────────────────────────────────────────────

describe('1. Método inválido', () => {
  it('retorna 405 para GET /judge', async () => {
    const req = new Request(JUDGE_URL, { method: 'GET' });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(405);
    const body = (await res.json()) as Record<string, unknown>;
    expect(typeof body['error']).toBe('string');
  });

  it('retorna 405 para PUT /judge', async () => {
    const req = new Request(JUDGE_URL, { method: 'PUT' });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(405);
  });

  it('retorna 405 para DELETE /judge', async () => {
    const req = new Request(JUDGE_URL, { method: 'DELETE' });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(405);
  });

  it('retorna 404 para rotas diferentes de /judge', async () => {
    const req = new Request('http://localhost/other', { method: 'POST', headers: JSON_HEADERS, body: VALID_BODY });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(404);
  });
});

// ─── 2. Content-Type inválido ─────────────────────────────────────────────────

describe('2. Content-Type inválido', () => {
  it('retorna 415 quando Content-Type é text/plain', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'text/plain' },
      body: 'texto simples',
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(415);
    const body = (await res.json()) as Record<string, unknown>;
    expect(typeof body['error']).toBe('string');
  });

  it('retorna 415 quando Content-Type está ausente', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(415);
  });

  it('retorna 415 para application/x-www-form-urlencoded', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'accusation=teste&excuse=teste',
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(415);
  });
});

// ─── 3. accusation vazia ──────────────────────────────────────────────────────

describe('3. accusation vazia', () => {
  it('retorna 400 quando accusation é string vazia', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: '', excuse: 'Estava dormindo' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });

  it('retorna 400 quando accusation contém apenas espaços (trim)', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: '   ', excuse: 'Estava dormindo' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });

  it('retorna 400 quando accusation está ausente do body', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ excuse: 'Estava dormindo' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });

  it('retorna 400 quando accusation é number', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: 42, excuse: 'Estava dormindo' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });
});

// ─── 4. excuse vazia ──────────────────────────────────────────────────────────

describe('4. excuse vazia', () => {
  it('retorna 400 quando excuse é string vazia', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: 'Chegou atrasado', excuse: '' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });

  it('retorna 400 quando excuse contém apenas espaços (trim)', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: 'Chegou atrasado', excuse: '   ' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });

  it('retorna 400 quando excuse está ausente do body', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: 'Chegou atrasado' }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });

  it('retorna 400 quando excuse é null', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: JSON.stringify({ accusation: 'Chegou atrasado', excuse: null }),
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(400);
  });
});

// ─── 5. MOCK_MODE — JSON compatível com VerdictModel ─────────────────────────

describe('5. MOCK_MODE retorna JSON compatível com VerdictModel', () => {
  it('retorna 200', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(200);
  });

  it('retorna Content-Type application/json', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.headers.get('Content-Type')).toContain('application/json');
  });

  it('retorna credibility entre 0 e 100', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    expect(typeof data['credibility']).toBe('number');
    expect(data['credibility']).toBeGreaterThanOrEqual(0);
    expect(data['credibility']).toBeLessThanOrEqual(100);
  });

  it('retorna creativity entre 0 e 100', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    expect(typeof data['creativity']).toBe('number');
    expect(data['creativity']).toBeGreaterThanOrEqual(0);
    expect(data['creativity']).toBeLessThanOrEqual(100);
  });

  it('retorna excuseLevel entre 0 e 100', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    expect(typeof data['excuseLevel']).toBe('number');
    expect(data['excuseLevel']).toBeGreaterThanOrEqual(0);
    expect(data['excuseLevel']).toBeLessThanOrEqual(100);
  });

  it('retorna verdict válido', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    const validVerdicts = ['ABSOLVIDO', 'CULPADO', 'PARCIALMENTE CULPADO'];
    expect(validVerdicts).toContain(data['verdict']);
  });

  it('retorna justification não-vazia', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    expect(typeof data['justification']).toBe('string');
    expect((data['justification'] as string).trim().length).toBeGreaterThan(0);
  });

  it('retorna punishment não-vazio', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    expect(typeof data['punishment']).toBe('string');
    expect((data['punishment'] as string).trim().length).toBeGreaterThan(0);
  });

  it('resposta contém exatamente os campos do VerdictModel', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    const data = (await res.json()) as Record<string, unknown>;
    const expectedKeys = [
      'credibility',
      'creativity',
      'excuseLevel',
      'verdict',
      'justification',
      'punishment',
    ];
    for (const key of expectedKeys) {
      expect(data).toHaveProperty(key);
    }
  });
});

// ─── 6. OPTIONS / CORS ────────────────────────────────────────────────────────

describe('6. OPTIONS / CORS', () => {
  it('retorna 200 para preflight OPTIONS /judge', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'OPTIONS',
      headers: { Origin: LOCALHOST_ORIGIN },
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(200);
  });

  it('reflete a origem localhost no Access-Control-Allow-Origin', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'OPTIONS',
      headers: { Origin: LOCALHOST_ORIGIN },
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe(LOCALHOST_ORIGIN);
  });

  it('inclui Access-Control-Allow-Methods correto', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'OPTIONS',
      headers: { Origin: LOCALHOST_ORIGIN },
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.headers.get('Access-Control-Allow-Methods')).toBe('POST, OPTIONS');
  });

  it('inclui Access-Control-Allow-Headers correto', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'OPTIONS',
      headers: { Origin: LOCALHOST_ORIGIN },
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.headers.get('Access-Control-Allow-Headers')).toBe('Content-Type');
  });

  it('inclui CORS headers em respostas POST bem-sucedidas', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: { ...JSON_HEADERS, Origin: LOCALHOST_ORIGIN },
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe(LOCALHOST_ORIGIN);
  });

  it('inclui CORS headers em respostas de erro (405)', async () => {
    const req = new Request(JUDGE_URL, {
      method: 'GET',
      headers: { Origin: LOCALHOST_ORIGIN },
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.status).toBe(405);
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe(LOCALHOST_ORIGIN);
  });

  it('aceita qualquer porta localhost (desenvolvimento Flutter)', async () => {
    const flutterOrigin = 'http://localhost:52341';
    const req = new Request(JUDGE_URL, {
      method: 'OPTIONS',
      headers: { Origin: flutterOrigin },
    });
    const res = await worker.fetch(req, mockEnv);
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe(flutterOrigin);
  });
});

// ─── 7. Integração Gemini com Mock de fetch ───────────────────────────────────

describe('7. Integração Gemini (chamadas mockadas via globalThis.fetch)', () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it('retorna 200 e dados válidos quando Gemini responde com sucesso estruturado', async () => {
    const geminiSuccessResponse = {
      candidates: [
        {
          content: {
            parts: [
              {
                text: JSON.stringify({
                  credibility: 85.0,
                  creativity: 90.0,
                  excuseLevel: 15.0,
                  verdict: 'ABSOLVIDO',
                  justification: 'Excelente justificativa técnica.',
                  punishment: 'Nenhuma punição aplicada.',
                }),
              },
            ],
          },
        },
      ],
    };

    vi.spyOn(globalThis, 'fetch').mockResolvedValueOnce(
      new Response(JSON.stringify(geminiSuccessResponse), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }),
    );

    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, realGeminiEnv);

    expect(res.status).toBe(200);
    const data = (await res.json()) as Record<string, unknown>;
    expect(data['verdict']).toBe('ABSOLVIDO');
    expect(data['credibility']).toBe(85.0);
  });

  it('retorna 429 quando Gemini responde com rate limit', async () => {
    vi.spyOn(globalThis, 'fetch').mockResolvedValueOnce(
      new Response(JSON.stringify({ error: 'RESOURCE_EXHAUSTED' }), {
        status: 429,
        headers: { 'Content-Type': 'application/json' },
      }),
    );

    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, realGeminiEnv);

    expect(res.status).toBe(429);
    const data = (await res.json()) as Record<string, unknown>;
    expect(data['error']).toBe('Rate limit reached. Try again later.');
  });

  it('retorna 502 quando Gemini retorna status 500 upstream', async () => {
    vi.spyOn(globalThis, 'fetch').mockResolvedValueOnce(
      new Response(JSON.stringify({ error: 'Internal Error' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }),
    );

    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, realGeminiEnv);

    expect(res.status).toBe(502);
    const data = (await res.json()) as Record<string, unknown>;
    expect(data['error']).toBe('Upstream API error');
  });

  it('retorna 502 e não vaza resposta bruta quando Gemini retorna dados fora do schema', async () => {
    const invalidGeminiResponse = {
      candidates: [
        {
          content: {
            parts: [
              {
                text: JSON.stringify({
                  credibility: 999.0, // inválido (> 100)
                  verdict: 'DESCONHECIDO', // inválido
                }),
              },
            ],
          },
        },
      ],
    };

    vi.spyOn(globalThis, 'fetch').mockResolvedValueOnce(
      new Response(JSON.stringify(invalidGeminiResponse), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }),
    );

    const req = new Request(JUDGE_URL, {
      method: 'POST',
      headers: JSON_HEADERS,
      body: VALID_BODY,
    });
    const res = await worker.fetch(req, realGeminiEnv);

    expect(res.status).toBe(502);
    const data = (await res.json()) as Record<string, unknown>;
    expect(data['error']).toBe('Invalid response from AI');
  });
});
