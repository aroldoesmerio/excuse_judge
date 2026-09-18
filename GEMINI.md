# GEMINI.md

Este documento define as diretrizes, decisões arquiteturais e regras de desenvolvimento do projeto **Excuse Judge**. Qualquer contribuição, refatoração ou assistência automatizada deve seguir rigorosamente os princípios descritos abaixo.

---

## 🎯 1. Objetivo e Contexto

* **Excuse Judge:** Um produto/experimento desenvolvido em Flutter com proposta divertida e gamificada para julgar desculpas cotidianas, avaliando métricas como credibilidade, criatividade e nível de desculpa, resultando em um veredito (absolvição ou condenação), justificativa e sentença.
* **Esmerio Experience:** Laboratório pessoal idealizado por Aroldo Esmerio para conceber, validar e construir produtos digitais reais através da prática, explorando novas tecnologias, boas práticas de engenharia de software e modelos de distribuição/monetização.

---

## 🛠️ 2. Stack Tecnológica e Ambiente

* **Flutter:** `3.47.2`
* **Dart:** `3.13.2`
* **Gerenciador de Versão:** **FVM** (Flutter Version Management) é a ferramenta padrão de versionamento do SDK no projeto.
* **Plataforma Principal:** **Flutter Web** é a plataforma foco neste momento (mantendo o código compatível com dispositivos móveis).

---

## 🏛️ 3. Arquitetura e Organização do Código

* **Feature-First com princípios de Clean Architecture:**
  * O código está estruturado em torno de features funcionais (ex.: `lib/features/tribunal/`), divididas em camadas com responsabilidades bem demarcadas: `domain`, `data` e `presentation`.
  * Recursos compartilhados e transversais pertencem a `lib/core/`.
* **Domain independente de Flutter:**
  * A camada de domínio (`domain/`) contém entidades, contratos de repositório e casos de uso puros em Dart. Ela **não** deve conter dependências de pacotes do Flutter (como `package:flutter/material.dart`).
* **Gerenciamento de Estado Atual com ValueNotifier:**
  * O `ValueNotifier` (em conjunto com `ValueListenableBuilder`) é a solução atual de gerenciamento de estado na camada de apresentação. O uso de outra solução no futuro só será permitido mediante necessidade técnica concreta e justificativa explícita.

---

## 📐 4. Padrões de Código e Design

* **Named Required Parameters:** Preferência explícita e consistente pelo uso de parâmetros nomeados e obrigatórios (`{required this.prop}`, `{required String excuse}`) em construtores e métodos para clareza e manutenibilidade.
* **Simplicidade acima de tudo:** Sempre priorizar a solução mais simples e direta para o problema.
* **Evitar Overengineering:** Não antecipar problemas futuros com soluções desnecessariamente complexas.
* **Uso Real de Abstrações:** Não criar interfaces, classes base, adaptadores ou camadas extras sem um uso real e comprovado.
* **Preservação de Comportamento:** Preservar o comportamento e as funcionalidades existentes ao realizar qualquer melhoria, permitindo alterações de comportamento apenas quando fizerem parte explícita do escopo solicitado.

---

## 🚫 5. Restrições e Limites Técnicos

* **Sem dependências supérfluas:** Não adicionar novos pacotes no `pubspec.yaml` sem necessidade estrita e validação prévia.
* **Sem frameworks de estado desnecessários:** Não introduzir Riverpod, Bloc, Provider, GetX ou Service Locator (GetIt, etc.) sem uma justificativa técnica concreta e aprovação explícita. O `ValueNotifier` atende o estágio atual do produto.
* **Integridade das Camadas:** Não alterar `domain` ou `data` por conveniência exclusiva da camada de `presentation`. A separação de responsabilidades deve ser respeitada.
* **Gemini como evolução planejada:** A integração com a API do Google Gemini faz parte do roadmap oficial para geração dos vereditos inteligentes, mas **não deve ser implementada agora**. A aplicação deve continuar operando com o `MockVerdictRepository` até a etapa correspondente.

---

## 🧪 6. Validação

Após qualquer alteração no código, deve-se validar o projeto executando:
* `fvm flutter analyze` para assegurar que não há alertas ou erros na análise estática.
* `fvm flutter test` (quando aplicável) para assegurar a integridade dos testes do projeto.

---

## 🔒 7. Regra Operacional Fundamental

> **Antes de alterar código, analise o estado atual e proponha os arquivos que serão modificados. Não altere arquivos fora do escopo solicitado.**
