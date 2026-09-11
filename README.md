# ⚖️ Excuse Judge

> **Toda desculpa merece um julgamento.**

Excuse Judge é um experimento de produto desenvolvido com Flutter que transforma desculpas do dia a dia em uma experiência divertida de julgamento.

A proposta é simples: você apresenta uma desculpa e o sistema determina se ela merece **absolvição ou condenação**.

O projeto faz parte da **Esmerio Experience**, meu laboratório pessoal para aprender construindo produtos digitais reais, explorando novas tecnologias e testando ideias que possam evoluir para produtos monetizáveis.

---

## 🎯 Objetivo

O projeto nasceu como um experimento para explorar a interseção entre:

* Flutter
* Engenharia de Software
* Inteligência Artificial
* Gamificação
* Experiências sociais
* Distribuição e monetização de produtos digitais

A primeira versão está focada na construção da experiência e da arquitetura do produto.

---

## 🚧 Status

**Em desenvolvimento**

Atualmente a aplicação utiliza um **Mock Repository** para simular o julgamento das desculpas.

A integração com um modelo de IA será adicionada em uma próxima etapa.

### Roadmap

* [x] Estrutura inicial do projeto
* [x] Arquitetura inicial
* [x] Interface inicial do Tribunal
* [x] Fluxo de julgamento utilizando Mock
* [ ] Integração com Gemini
* [ ] Resposta estruturada da IA
* [ ] Histórico de julgamentos
* [ ] Compartilhamento dos vereditos
* [ ] Entrada por voz
* [ ] Gamificação
* [ ] Monetização
* [ ] Novas experiências

---

## 🛠️ Stack atual

* **Flutter 3.47.2**
* **Dart 3.13.2**
* **FVM 4.3.1**
* **Flutter Web**
* **ValueNotifier**
* **Clean Architecture**
* **Git**

Tecnologias previstas para as próximas etapas:

* Gemini
* Backend
* PostgreSQL / Supabase
* APIs
* Recursos de voz
* Analytics
* Publicidade

---

## 🏗️ Arquitetura

O projeto utiliza uma organização orientada a features:

```text
lib/
├── core/
│
├── features/
│   └── tribunal/
│       ├── data/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
│
└── main.dart
```

A intenção é manter as responsabilidades separadas e permitir que a implementação atual baseada em Mock seja substituída posteriormente por uma implementação real utilizando IA sem acoplar a interface à infraestrutura.

---

## 🧪 Desenvolvimento

O projeto utiliza **FVM** para controlar a versão do Flutter por projeto.

### Versão do Flutter

```bash
fvm flutter --version
```

### Análise estática

```bash
fvm flutter analyze
```

### Executar no Web Server

```bash
fvm flutter run -d web-server
```

O projeto foi configurado inicialmente para desenvolvimento Web, mantendo o Android disponível para testes futuros.

---

## 🧠 Sobre o projeto

O Excuse Judge não pretende ser apenas um exercício de programação.

Ele está sendo utilizado como um laboratório prático para explorar o ciclo completo de construção de um produto:

```text
Ideia
  ↓
Experiência
  ↓
Arquitetura
  ↓
Desenvolvimento
  ↓
IA
  ↓
Distribuição
  ↓
Métricas
  ↓
Monetização
```

O objetivo é aprender construindo, evoluindo o produto gradualmente conforme novas competências técnicas forem incorporadas.

---

## 👨‍💻 Autor

**Aroldo Esmerio**

Flutter Developer | Software Engineering | AI Product Engineering

Este projeto faz parte da **Esmerio Experience**.

[LinkedIn](https://www.linkedin.com/in/aroldo-esmerio-30274975/) · [GitHub](https://github.com/aroldoesmerio)
