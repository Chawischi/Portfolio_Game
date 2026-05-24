# 📋 Game Design Document
# 🏔️ One Last Climb

| | |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Pesquisa / Prototipagem |
| **Versão** | v0.5 |
| **Última atualização** | 12/04/2026 |

---

> *"A última escalada prometida."*

**One Last Climb** é um jogo de plataforma 2D desenvolvido como projeto de portfólio acadêmico. O jogador controla **Eugene**, um velhinho teimoso e determinado que decide escalar uma montanha inteira para cumprir a última promessa que fez à sua esposa: espalhar as cinzas dela no cume.

Como o caminho oficial está bloqueado, Eugene não tem escolha — terá que ir pelo de dentro. Por uma mina escura, claustrofóbica e cheia de obstáculos.

---

## 🎮 Sobre o jogo

O jogo é **divertido primeiro**. Pular, dar dash, fazer wall jump e escalar paredes com precisão é o coração da experiência. A narrativa emocional entra pelas beiradas — nas flores que Eugene coleta pelo caminho e nos **sonhos que ele tem nos checkpoints**, onde ouve a voz de Liliana.

O jogador começa achando que está jogando uma aventura leve de um velhinho cabeçudo. Só lá na frente percebe que estava sendo partido aos poucos.

| | |
|---|---|
| **Gênero** | Plataforma 2D / Aventura / Narrativo |
| **Engine** | Godot 4.x |
| **Plataformas** | PC (Windows) · Web (itch.io) |
| **Controles** | Teclado |
| **Status** | Prototipagem |

---

## 🗺️ A jornada

O jogo se divide em **5 fases**, cada uma representando um trecho da escalada:

| Fase | Ambiente | Tom |
|---|---|---|
| 1 | Base da montanha — floresta e trilha | Leve. Eugene reclama, mas segue. |
| 2 | Entrada da caverna — pedras e raízes | A leveza começa a pesar. |
| 3 | Caverna profunda | O humor diminui. As memórias ficam mais pesadas. |
| 4 | Caverna densa — o ponto mais difícil | Eugene para de falar. Só continua. |
| 5 | Caverna clareando → cume | A luz volta. Eugene chora — mas chega. |

Cada fase segue uma estrutura de três partes: **apresenta** a mecânica, **mistura** os elementos e traz o **desafio** consolidado.

---

## 🎯 Mecânicas

Todas as habilidades estão disponíveis desde o início — é o level design que ensina quando e como usá-las:

- **Pulo e pulo duplo**
- **Dash** — impulso horizontal rápido
- **Wall jump** — saltar entre paredes
- **Escalada** — subir superfícies verticais

---

## 💭 Os sonhos

Nos checkpoints, Eugene dorme. A tela escurece. A voz de Liliana fala — uma citação, um conselho, um momento do passado deles. Eugene resmuga algo ao acordar, no tom dele: entre o soturno e o involuntariamente engraçado.

> *"O destino sempre acha um jeito. Você também vai achar."*
> *— Liliana*
>
> *"O destino sou eu escalando essa montanha ridícula."*
> *— Eugene*

---

## 🎨 Direção visual

Pixel art com resolução base **320×180**, ampliada em múltiplos inteiros. A paleta muda conforme a jornada:

- 🌿 **Floresta** — verdes terrosos, tons quentes e naturais
- ⛏️ **Mina** — cinzas azulados, escuridão, iluminação pontual
- ☀️ **Cume** — verdes vivos, luz dourada, céu aberto

---

## 🏗️ Tecnologias

| Categoria | Ferramenta |
|---|---|
| Engine | Godot 4.x |
| Linguagem | GDScript |
| Arte | Aseprite |
| Versionamento | Git + GitHub |
| Build Web | WebGL → itch.io |

---

## 📁 Estrutura do repositório

```
📦 Portfolio_Game
├── 📂 Build/        → builds exportados
├── 📂 Docs/         → GDD e documentação
├── 📂 Scenes/       → cenas do Godot
├── 📂 Scripts/      → scripts GDScript
└── 📂 Sprites/      → assets visuais
```

---

## 📋 Documentação

O Game Design Document completo está disponível em [`Docs/`](./Docs/).

---

## 👤 Autor

**Felipe da Silva Chawischi**
felipe.chawischi@catolica.edu

---

## 📄 Licença

Código sob licença **MIT**.
Assets de áudio externos sob **CC-BY** — autores creditados na tela de créditos do jogo.
Assets visuais externos sob **CC0**.