# ONE LAST CLIMB
## Game Design Document — v1.0 | Junho/2026

| Campo | Info |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Prototipagem |
| **Versão** | v1.0 |
| **Última atualização** | Junho/2026 |

---

## 1. Visão Geral

### Elevator Pitch

One Last Climb é um jogo de plataforma 2D com movimentação ágil e progressiva, onde o jogador controla Eugene, um velhinho teimoso e determinado. O jogo é divertido primeiro: saltar, dar dash e escalar paredes com precisão é o coração da experiência. A narrativa emocional entra pelas beiradas — nas flores que Eugene coleta pelo caminho e nos sonhos que ele tem nos checkpoints, onde ouve a voz de Liliana. O jogador começa achando que está jogando uma aventura leve de um velhinho cabeçudo. Só lá na frente percebe que estava sendo partido aos poucos.

### Gênero

- **Gênero Principal:** Plataforma 2D
- **Gêneros Secundários:** Aventura, Narrativo

### Público-Alvo

Jogadores casuais e intermediários, principalmente entre adolescentes e adultos (16–35 anos), que apreciam experiências emocionais combinadas com desafios leves a moderados.

### Plataformas

- PC (Windows)
- Web via itch.io (build WebGL)

---

## 2. Acesso ao Projeto

| Item | Link |
|---|---|
| Build jogável | itch.io — a preencher |
| Repositório | https://github.com/Chawischi/Portfolio_Game |
| Vídeo gameplay (opcional) | YouTube — a preencher |
| Instruções de execução | Godot 4.x \| Windows 10+ \| Teclado |

---

## 3. Personagens

### Eugene — O Protagonista

Idoso teimoso e determinado a cumprir a última vontade da esposa: levar as cinzas de Liliana ao topo de uma montanha. Como o caminho oficial está bloqueado, Eugene enfrenta a trilha interna — sozinho e sem pedir ajuda para ninguém, porque é exatamente esse tipo de velho. Sua jornada é tanto física (escalar a montanha) quanto emocional (superar a perda e honrar a memória de Liliana).

No gameplay, Eugene começa com todas as habilidades disponíveis desde o início. O jogador vai dominando o conjunto de mecânicas progressivamente conforme as fases exigem e ensinam seu uso.

### Liliana — A Esposa

Presente no jogo apenas através das memórias, das flores e das frases que surgem nos sonhos de Eugene nos checkpoints. Nunca aparece diretamente no gameplay — sua presença é construída pela ausência.

- Nome de origem latina (*lilium*) — significa lírio, a flor central do jogo
- Raízes gregas (*Elisábet*) — "meu Deus é um juramento" — ligação simbólica com a promessa do jogo
- Apaixonada por história e literatura, o que justifica as citações que ela deixou na vida de Eugene

---

## 4. Pesquisa e Referências

### Jogos de Referência

#### Celeste (2018) — Maddymakesgames
Plataforma 2D com mecânicas precisas de dash e pulo, equilibrando dificuldade elevada com narrativa emocional.
- Inspira: estrutura mostrar→misturar→desafiar, feedback visual e sonoro de qualidade.

#### Hollow Knight (2017) — Team Cherry
Plataforma 2D com atmosfera subterrânea densa e iluminação pontual expressiva.
- Inspira: design da caverna, uso de luz pontual em fundo escuro, expressão emocional via sprite pequeno.

#### A Short Hike (2019) — adamgryu
Exploração casual com subida de montanha em ritmo próprio.
- Inspira: progressão orgânica, ritmo contemplativo, sensação de conquista no cume.

### Mood Board

![Mood Board](https://github.com/user-attachments/assets/f0852070-2789-4655-a53d-e289e971b551)

### Análise das Referências

| Jogo | O que faz bem | O que inspirou |
|---|---|---|
| Celeste | Ensino de mecânicas integrado ao level design | Estrutura mostrar → misturar → desafiar por fase |
| Hollow Knight | Atmosfera subterrânea com iluminação pontual | Design da caverna; expressão emocional via sprite pequeno |
| A Short Hike | Progressão orgânica; ritmo contemplativo | Estrutura de subida de montanha; conquista no cume |

---

## 5. Hipóteses de Design

| Hipótese | Método de Teste | Critério de Confirmação |
|---|---|---|
| Jogadores se conectam emocionalmente com personagens idosos | Playtest com mínimo de 5 participantes; perguntas pós-sessão sobre empatia | 70% relatam conexão ou empatia com Eugene |
| Lírios incentivam exploração | Observação direta: registrar se jogadores buscam ou ignoram as flores | 60% coletam ao menos metade dos lírios sem instrução explícita |
| Estrutura mostrar→misturar→desafiar ensina sem tutorial explícito | Medir tentativas até completar cada parte da fase | 90% completam a Parte 1 da Fase 1 em até 3 tentativas |
| Sonhos nos checkpoints não interrompem o ritmo | Perguntar pós-sessão se os sonhos foram intrusivos ou emocionantes | Menos de 20% relatam os sonhos como intrusivos |
| Tom leve potencializa impacto emocional | Registrar reações verbais e expressões durante a cena final | 50% demonstram reação emocional notável na cena do cume |

### Pilares do Jogo

- **Gameplay divertido primeiro** — movimento ágil, responsivo e satisfatório é a base de tudo.
- **Leveza como veículo da emoção** — assuntos sérios embalados com superfície leve (tática Disney).
- **Progressão orgânica** — cada fase ensina, mistura e desafia pelo level design.
- **Contemplação e descoberta** — o ambiente recompensa quem explora.

---

## 6. Gameplay

### Core Loop

O núcleo do jogo é o movimento. A narrativa entra como recompensa — nos checkpoints (sonhos de Liliana) e nos lírios coletados (álbum de memórias).

> Explorar a fase → superar obstáculos → ativar checkpoint → Eugene dorme → ouve Liliana → resmuga ao acordar → avançar → repetir

### Loops Secundários

- Coletar todos os lírios da fase para completar o buquê e desbloquear o **Final Verdadeiro**
- Dominar o encadeamento das habilidades de movimentação

### Mecânicas Principais

Todas as habilidades estão disponíveis desde o início. O level design apresenta, mistura e desafia progressivamente.

| Mecânica | Descrição |
|---|---|
| Pulo simples | Responsivo e preciso — base de toda a movimentação. |
| Pulo duplo | Segundo pulo no ar para alcançar plataformas mais altas. |
| Dash | Impulso horizontal rápido e satisfatório. **Não possui i-frames** — qualquer contato com inimigo durante o dash causa dano normalmente. |
| Wall jump | Saltar entre paredes em sequência rápida. Exige timing e recompensa o domínio. |
| Escalada | Agarrar e subir superfícies verticais. Possui limite de resistência: quando esgotado, Eugene começa a tremer e escorrega até cair. O feedback é visual no sprite (tremor e leve mudança de cor), sem barra explícita no HUD. |

### Mockups das Mecânicas

![Mockup — Mecânica de andar](https://github.com/user-attachments/assets/6ea9627d-c101-4f3a-b059-066fa60b57be)

![Mockup — Mecânica de pulo](https://github.com/user-attachments/assets/eba0fdc3-3983-4de7-ae82-c294b752d013)

![Mockup — Mecânica de pulo duplo](https://github.com/user-attachments/assets/026e3c85-4339-4ea3-96d2-3867a73ee955)

![Mockup — Mecânica de dash](https://github.com/user-attachments/assets/d8fffd32-e05a-472c-9430-762663d4359f)

![Mockup — Mecânica de escalar](https://github.com/user-attachments/assets/6dd31a5c-7f5b-4193-8075-3d343bfa5471)

![Mockup — Mecânica de wall jump](https://github.com/user-attachments/assets/171caa12-c121-438d-b966-d0c64e30e4c3)

### Câmera

Lateral 2D com scroll suave. Offsets verticais antecipam plataformas acima. Escurece suavemente nos checkpoints.

### Sistemas

**Vitória — Dois Finais**

O desfecho do jogo é determinado pela coleta dos lírios ao longo das fases:

| Final | Condição | O que acontece |
|---|---|---|
| **Final Verdadeiro (Feliz)** | Jogador coletou todos os lírios e completou o buquê | Eugene chega ao topo, realiza o ritual completo e espalha as cinzas com o buquê. Cena de encerramento emocionante e reconfortante. |
| **Final Trágico** | Jogador não coletou todos os lírios | Eugene chega ao topo, mas antes de completar o ritual sofre um ataque do coração e cai. Morre no cume sem cumprir a promessa — sozinho, sem o buquê, sem o ritual. |

> 📌 A existência de dois finais dá peso real à coleta dos lírios: não é opcional, é a diferença entre Eugene cumprir ou não a sua última promessa.

**Derrota:** Contato com inimigos ou queda em abismo. Eugene é reposicionado imediatamente no último checkpoint ativado — o respawn é silencioso para preservar o ritmo da gameplay.

**Progressão:** A cada checkpoint ativado **pela primeira vez**, Eugene dorme e o sonho de Liliana é exibido. Nas mortes subsequentes, o respawn é direto — o sonho não se repete.

---

## 7. Sistema de Sonhos e Checkpoints

Esta é a mecânica que conecta gameplay e narrativa.

### Como funciona

1. Eugene ativa um checkpoint (fogueira ou sinal de descanso)
2. **Na primeira ativação:** a tela escurece suavemente, Eugene dorme, a voz de Liliana fala uma frase, Eugene resmuga ao acordar
3. **Nas ativações seguintes (respawn após morte):** o reposicionamento é imediato e silencioso — o sonho não se repete
4. O jogo retoma normalmente do ponto do checkpoint

> 📌 Esta regra preserva o ritmo ágil da gameplay. Morrer repetidas vezes não força o jogador a rever o mesmo diálogo.

### Falas por Checkpoint

| # | Checkpoint | Fala de Liliana | Resmungo de Eugene |
|---|---|---|---|
| 1 | Entrada da mina | *"O amor empurra a gente pra frente, Eugene. Sempre empurrou."* | *"...Ela e o latim dela. Vai, Eugene."* |
| 2 | Caverna média | *"Enquanto você respirar, você tem esperança. Não esqueça disso."* | *"Ainda respiro. Ainda tô aqui."* |
| 3 | Caverna profunda I | *"O destino sempre acha um jeito. Você também vai achar."* | *"O destino sou eu escalando essa montanha ridícula."* |
| 4 | Caverna profunda II | *"A memória dos que amamos nunca morre. Eu sempre vou estar aqui."* | *"...Eu sei, Lily. Eu sei."* |
| 5 | Saída da mina | *"Pelos astros e pelas dificuldades, Eugene. Você já chegou lá."* | *"Quase lá. Quase."* |

### Frases de Eugene em Momentos-Chave

| Momento | Frase de Eugene |
|---|---|
| Ao iniciar a jornada | *"A última escalada prometida."* |
| Durante a escalada | *"Por você minha querida, qualquer coisa."* |
| Ao chegar ao topo (Final Verdadeiro) | *"Pronto, Lily. Como prometido."* |
| Ao cair no cume (Final Trágico) | *[Sem fala — Eugene cai em silêncio]* |

---

## 8. Estrutura das Fases

5 fases representando trechos progressivos da escalada. Cada fase segue a estrutura mostrar→misturar→desafiar. Plataformas estão presentes em todas as fases.

### Wireframe de Level Design

![Wireframe de Level Design](https://github.com/user-attachments/assets/ba65cb95-a63e-47c9-bdfa-bc1521ceacb5)

### Layout — Zona 1 (Fase 1)

![Layout Zona 1](https://github.com/user-attachments/assets/caf47c73-be4d-46f4-b21c-40a685f94c47)

### Fase 1 — Base da montanha (floresta e trilha inicial)
*Tom: introdução leve. Eugene começa reclamando da subida.*

| Parte | Descrição |
|---|---|
| Parte 1 | Tutorial integrado ao gameplay no estilo Celeste: o level design ensina os controles sem texto excessivo. |
| Parte 2 | Eugene se depara com uma placa bloqueando o caminho oficial. Decide seguir pela entrada da mina. |
| Parte 3 | Entrada na caverna. Ambiente escurece. Desafio de plataforma sem inimigos — apresenta o tom do que virá. |

### Fase 2 — Entrada da caverna
*Tom: transição. O caminho começa a pesar, mas Eugene ainda faz piada.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e morcegos simples. Apresenta o inimigo e seu padrão de patrulha. |
| Parte 2 | Plataformas e mais morcegos. Volume aumenta e posicionamentos ficam desafiadores. |
| Parte 3 | Plataformas e enxame de morcegos. Desafio consolidado do inimigo principal da fase. |

### Fase 3 — Caverna profunda
*Tom: o humor diminui. As memórias ficam mais pesadas.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e estalagmites. Apresenta o obstáculo e seu comportamento. |
| Parte 2 | Plataformas e mais estalagmites em combinações mais complexas. |
| Parte 3 | Tudo junto: morcegos, estalagmites e grande subida vertical em túnel estilo poço de elevador com plataformas em cordas. Conecta visualmente com a Fase 4. |

### Fase 4 — Caverna densa (ponto mais difícil)
*Tom: momento mais sombrio. Eugene para de falar. Só continua.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas penduradas em corda sem chão firme — continua o sistema da Fase 3. |
| Parte 2 | Plataformas penduradas com estalagmites — exige timing preciso em terreno instável. |
| Parte 3 | Tudo junto na dificuldade máxima: plataformas penduradas, estalagmites e morcegos. |

### Fase 5 — Caverna clareando → cume
*Tom: alívio. A luz volta. O desfecho depende dos lírios coletados.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e estalagmites. O ambiente já clarea — o fim está próximo. |
| Parte 2 | Igual à Parte 1, dificuldade aumentada. A luz continua crescendo. |
| Parte 3 | Na saída da caverna, um enxame de morcegos aparece de surpresa — susto final, mas o céu já é visível ao fundo. |
| Parte 4 (Cena Final) | Eugene chega ao topo. O desfecho é determinado pelos lírios coletados: Final Verdadeiro (ritual completo) ou Final Trágico (ataque do coração antes do ritual). |

---

## 9. Inimigos e Obstáculos

### Inimigos

| Inimigo | Fase(s) | Comportamento | Regras de colisão |
|---|---|---|---|
| Morcego (sozinho) | 1, 2, 3, 5 | Patrulha lateral no ar; ao detectar o jogador, avança em linha reta | Pular em cima **elimina** o morcego sem causar dano (stomp). Contato lateral ou pelo dash causa dano. |
| Enxame de morcegos | 2, 3, 5 (Parte 3) | Grupo em formação; comportamento coletivo agressivo | Nenhuma forma de stomp válida — **qualquer contato causa dano.** |
| Estalagmite instável | 3, 4, 5 | Estática no teto; vibra ao se aproximar, cai após alguns segundos | Dano ao cair sobre Eugene. Inofensiva enquanto presa no teto. |

### Regras Gerais de Colisão

- O **dash não possui i-frames** — qualquer contato com inimigo durante o dash causa dano normalmente.
- **Stomp** (pular em cima) funciona apenas em morcegos isolados, nunca no enxame.
- A estalagmite só causa dano durante a queda — não é possível encostar nela enquanto está presa no teto.

### Obstáculos Ambientais

- Abismos entre plataformas
- Plataformas móveis e penduradas em cordas (fases 3, 4 e 5)
- Trechos de parede para wall jump obrigatório

---

## 10. Escopo do Projeto

### O jogo inclui

- 5 fases com 3 partes cada (+ cena final na Fase 5)
- 4 mecânicas de movimentação + escalada, todas disponíveis desde o início
- 5 sonhos narrativos nos checkpoints (tela preta + fala de Liliana + resmungo de Eugene)
- Sistema de lírios colecionáveis que determina o final obtido
- **Dois finais:** Final Verdadeiro (coleta completa) e Final Trágico (coleta incompleta)
- 2 tipos de inimigo: morcego e estalagmite instável
- Menu principal, pausa e tela de game over
- Trilha sonora e efeitos sonoros
- Sistema de save local

### O jogo não inclui

- Multiplayer
- Sistema de crafting ou inventário
- Geração procedural de fases
- Localização para outros idiomas
- Sistema de save em nuvem

---

## 11. Prototipagem

| Protótipo | Objetivo | Resultado |
|---|---|---|
| Movimentação básica | Validar pulo e movimentação lateral | A preencher |
| Pulo duplo | Testar sensibilidade e feel | A preencher |
| Dash | Testar sensibilidade e feel | A preencher |
| Wall jump | Testar sensibilidade e feel | A preencher |
| Escalada | Validar agarrar e subir superfícies | A preencher |
| Sonho (checkpoint) | Validar tela preta + fala + resmungo | A preencher |
| Inimigo morcego | Testar patrulha e dano por contato | A preencher |
| Estalagmite instável | Testar gatilho de queda e dano | A preencher |
| Sistema de dois finais | Validar verificação de lírios e disparo do final correto | A preencher |

---

## 12. Interface (UI/UX)

### HUD

- **Indicador de resistência na escalada** — sem barra explícita. O feedback é dado pelo sprite de Eugene: ele começa a tremer e sofre leve mudança de cor. Ao esgotar, escorrega e cai.
- Indicador discreto de flores coletadas na fase (canto superior direito)
- HUD oculto durante os sonhos nos checkpoints

### Menus

- **Menu principal:** Jogar, Continuar, Opções, Sair
- **Menu de pausa:** Retomar, Álbum de Memórias, Opções, Menu Principal. É também por aqui que o jogador pode sair do jogo.
- **Game over:** tela preta simples, possivelmente com um símbolo visual. O jogo retoma automaticamente do último checkpoint após alguns segundos, sem botões ou interação.
- **Opções:** Controles (remapeável), Áudio (Geral/Música/SFX), Vídeo (Fullscreen/V-Sync/UI)

### Flow de Telas

![Flow de Telas](https://github.com/user-attachments/assets/260b08ea-f710-410a-8623-0306814205b1)

### Wireframes de Menus e HUD

![Wireframes](https://github.com/user-attachments/assets/0f26a289-6896-4fc0-b050-fc4cba5ee644)

### Controles — Teclado

| Ação | Tecla |
|---|---|
| Mover | A / D ou setas |
| Pular / Pulo duplo | Espaço / W / seta cima |
| Dash | E ou Shift + direcional |
| Wall jump | Pulo ao encostar na parede |
| Escalada | Aproximar da superfície + direcional |
| Pausar | Esc |

---

## 13. Direção Visual

### Direção de Arte

Pixel art com resolução base 320×180, ampliada em múltiplos inteiros. Personagens ~16×16 px, tilesets 8×8 px. Filtro Nearest no Godot.

### Paleta de Cores — Jornada do Jogador

![Paleta de Cores](https://github.com/user-attachments/assets/41f64bd2-6782-4bb7-9161-434cbc9a9e7e)

#### Floresta Inicial

| Papel | Cor | Hex |
|---|---|---|
| Dominante | Verde floresta | `#4A7C3F` |
| Verde médio | — | `#7AAD5A` |
| Secundária | Marrom terra | `#7B4F28` |
| Destaque | Azul céu | `#5A7A8C` |

#### Mina

| Papel | Cor | Hex |
|---|---|---|
| Dominante | Cinza escuro | `#2A3040` |
| Pedra média | — | `#3D4A5C` |
| Secundária | Cinza médio | `#4A5060` |
| Destaque claro | Ciano mineral | `#1ECFC0` |
| Lanterna âmbar | — | `#EFA827` |
| Perigo/lava | — | `#E84A4A` |

#### Topo da Montanha

| Papel | Cor | Hex |
|---|---|---|
| Dominante | Verde vivo | `#5AAD3C` |
| Secundária | Amarelo sol | `#E8A820` |
| Luz dourada | — | `#F4CC60` |
| Destaque céu | Azul claro | `#60B4E8` |
| Pôr do sol | — | `#D07848` |

### Referências Visuais

- **Celeste** — pixel art expressivo, paralaxe de montanha, uso emocional de cor
- **Hollow Knight** — atmosfera subterrânea com iluminação pontual
- **Carl (UP, Pixar)** — postura curvada e expressão fechada comunicam idade e determinação

### Configuração Pixel Art no Godot

| Configuração | Valor | Onde |
|---|---|---|
| Resolução base | 320×180 | Project Settings → Display → Window |
| Filtro de textura | Nearest | Project Settings → Rendering → Textures |
| Stretch Mode | viewport | Project Settings → Display → Window → Stretch |
| Stretch Aspect | keep | Project Settings → Display → Window → Stretch |
| Snap 2D Transforms | Ativo | Project Settings → Rendering → 2D |
| Snap 2D Vertices | Ativo | Project Settings → Rendering → 2D |

---

## 14. Áudio

| Tipo | Onde usar | Loop? | Descrição |
|---|---|---|---|
| Música ambiente | Fases jogadas | Sim | Piano e cordas suaves, melancolia serena |
| Música de sonho | Checkpoints — tela preta | Não | Tema nostálgico, quente e aconchegante |
| Trilha de tensão | Proximidade de inimigos | Sim | Elevação sutil, sem ser agressiva |
| SFX pulo | A cada pulo | Não | Som leve |
| SFX dash | Ao usar o dash | Não | Whoosh curto e preciso |
| SFX coleta de flor | Ao pegar o lírio | Não | Nota musical suave |
| SFX dano | Ao sofrer dano | Não | Impacto leve |
| SFX checkpoint | Ao ativar checkpoint | Não | Som reconfortante |
| Música Final Verdadeiro | Cena do cume — Final Feliz | Não | Tema principal em versão plena, emotiva |
| Música Final Trágico | Cena do cume — Final Trágico | Não | Versão incompleta ou silenciosa do tema |

---

## 15. Animação

| Animação | Personagem/Objeto | Loop? | Descrição |
|---|---|---|---|
| Idle | Eugene | Sim | Respiração suave, leve balanço |
| Caminhar | Eugene | Sim | Passo cadenciado, postura curvada de idoso |
| Pulo | Eugene | Não | Subida e descida com frames distintos |
| Pulo duplo | Eugene | Não | Segundo pulo com efeito visual distinto |
| Dash | Eugene | Não | Frames rápidos com trilha de partículas |
| Wall slide | Eugene | Sim | Corpo raspando a parede |
| Escalada | Eugene | Sim | Movimento de subida em superfície vertical |
| Tremor (resistência baixa) | Eugene | Sim | Tremor e leve mudança de cor ao se aproximar do limite |
| Dano | Eugene | Não | Flash e recuo rápido |
| Dormir (checkpoint) | Eugene | Sim | Fecha os olhos e a tela escurece |
| Queda (Final Trágico) | Eugene | Não | Eugene cai no cume antes de completar o ritual |
| Idle patrulha | Morcego | Sim | Movimento lateral de patrulha |
| Ataque | Morcego | Não | Avanço em linha reta |
| Vibração | Estalagmite | Sim | Tremor crescente antes de cair |
| Queda | Estalagmite | Não | Queda vertical |
| Flutuação | Lírio (item) | Sim | Balanço suave com brilho pulsante |

---

## 16. Arquitetura de Software

O projeto será estruturado em Godot 4 com GDScript, seguindo separação de responsabilidades por scripts e Autoloads para sistemas globais.

| Sistema | Tipo | Responsabilidades |
|---|---|---|
| GameManager | Autoload | Estado global, transições de cena, progresso e contagem de lírios coletados |
| PlayerController | Script (FSM) | Input, física e animações de Eugene. Implementado como **Máquina de Estados Finitos (FSM)** para controle rigoroso das transições (Idle, Walk, Jump, DoubleJump, Dash, WallSlide, Climb, Hurt, Dead) |
| EnemyBase | Script (base) | Classe base para inimigos. Morcego e estalagmite herdam desta classe |
| CheckpointSystem | Script | Ativação de checkpoints, disparo dos sonhos na primeira visita e respawn silencioso |
| FlowerSystem | Script | Coleta de lírios, álbum de memórias e verificação da condição para o Final Verdadeiro |
| EndingManager | Script | Verificação do buquê completo ao atingir o cume e disparo do final correto |
| UIManager | Script | HUD, menus, álbum e transições de tela |
| AudioManager | Autoload | Reprodução e mistura de músicas e efeitos sonoros |

### Padrões de Projeto Aplicados

- **FSM** — `PlayerController`: garante que apenas um estado de movimentação esteja ativo por vez e que as transições (ex: Jump → WallSlide → WallJump) sejam controladas e previsíveis.
- **Observer (Signals do Godot)** — `CheckpointSystem` emite sinal ao ser ativado; `AudioManager` e `UIManager` reagem sem acoplamento direto.
- **Singleton (Autoload)** — `GameManager` e `AudioManager` são acessíveis globalmente sem dependência de cena.

### Tecnologias Utilizadas

| Categoria | Ferramenta |
|---|---|
| Engine | Godot 4.x |
| Linguagem | GDScript |
| Versionamento | Git + GitHub |
| Arte / Sprites | Aseprite (pixel art) |
| Áudio | Audacity / assets livres de royalties |
| Build Web | Exportação WebGL do Godot → itch.io |

---

## 17. Testes e Playtests

### Plano de Testes por Mecânica

> 📌 Critérios de aceitação definidos antes da execução dos playtests. Mínimo de 5 participantes por sessão.

| Mecânica | Critério de Aceitação |
|---|---|
| Pulo simples | 90% executam sem instrução explícita na Parte 1 da Fase 1 |
| Pulo duplo | 80% percebem e utilizam o pulo duplo na Parte 2 sem dica |
| Dash | 80% conseguem usar o dash em situação de combate até a Fase 2 |
| Wall jump | 70% conseguem wall jump consecutivo sem instrução até o fim da Fase 3 |
| Escalada + resistência | 80% compreendem o limite de resistência pelo feedback visual (tremor) sem barra de HUD |
| Sistema de checkpoints | 100% entendem que morrem e voltam ao checkpoint sem confusão |
| Sonhos nos checkpoints | Menos de 20% relatam os sonhos como intrusivos |
| Sistema de dois finais | 80% entendem, após o primeiro final obtido, que a coleta de lírios influencia o desfecho |

### Resultados dos Playtests

| Data | Participantes | Principais problemas |
|---|---|---|
| A preencher | A preencher | A preencher após realização dos playtests |

### Melhorias Implementadas

> A preencher após os ciclos de playtest.

---

## 18. Cronograma

| Milestone | Período previsto | Descrição |
|---|---|---|
| Pesquisa e GDD | Março – Junho/2026 | Documentação, referências e reestruturações de design |
| Protótipo de movimentação | Maio – Junho/2026 | Todas as mecânicas jogáveis |
| Fase 1 jogável | Junho/2026 | Arte, level design (3 partes) e primeiro sonho integrados |
| Fases 2 e 3 | Julho/2026 | Inimigos, plataformas penduradas e sistema de sonhos |
| Fases 4 e 5 + sistema de finais | Agosto/2026 | Conclusão do conteúdo, dois finais, cena final e áudio |
| Polimento e playtests | Setembro/2026 | Ajustes de dificuldade, bugs, UI e álbum |
| Build final + entrega | Outubro/2026 | Versão final para avaliação |

---

## 19. Riscos do Projeto

| Risco | Impacto | Mitigação |
|---|---|---|
| Escopo de arte muito grande | Atraso na produção | Limitar assets; reutilizar sprites com variações e flip |
| Level design de 5 fases (3 partes cada) | Escopo inflado | Priorizar Fases 1–3; 4 e 5 como expansão controlada |
| Narrativa emocional não ressoar | Jogo perde identidade | Playtest cedo com foco em feedback emocional |
| Performance no WebGL | Experiência ruim no navegador | Testar build web desde as fases iniciais |
| Falta de tempo para polimento | Entrega com bugs | Buffer de 2 semanas antes da entrega |
| Assets de áudio com licenças incompatíveis | Problemas de distribuição | Usar só CC0 e CC-BY; documentar tudo nos créditos |
| Sistema de dois finais adiciona complexidade | Bugs no controle de estado | EndingManager isolado e testado em protótipo antes da Fase 5 |

---

## 20. Limitações Conhecidas

- Multiplayer não será implementado
- Sistema de save em nuvem fora do escopo (save local)
- Localização apenas em português
- Arte criada pelo aluno: qualidade sujeita a evolução
- Suporte apenas a teclado (sem gamepad nesta versão)

---

## 21. Decisões Importantes

| Data | Decisão | Motivo |
|---|---|---|
| Abril/2026 | Pixel art como estilo visual | Domínio do Aseprite; coerente com as referências |
| Abril/2026 | Godot 4 como engine | Open source, leve, WebGL excelente, GDScript acessível |
| Abril/2026 | 5 fases como escopo | Equilíbrio entre conteúdo e viabilidade para TCC solo |
| Abril/2026 | Fase 5 sem inimigos até a saída | Metáfora: caminho final é de contemplação; enxame final é susto narrativo |
| Abril/2026 | Tom leve na superfície, emoção pesada por baixo | Impacto emocional maior quando o jogador é pego de surpresa |
| Maio/2026 | Flashbacks substituídos por sonhos nos checkpoints | Mais imersivo; menos arte necessária; tela preta é mais direta |
| Maio/2026 | Todas as habilidades desde o início | Level design ensina organicamente; sem bloqueio artificial |
| Maio/2026 | Estrutura de 3 partes por fase (estilo Nintendo) | Apresenta, mistura e desafia de forma clara |
| Maio/2026 | Suporte apenas a teclado | Foco no escopo; simplifica testes |
| Maio/2026 | Sonho exibido apenas na primeira ativação | Respawn silencioso preserva o ritmo ágil |
| Maio/2026 | Dash sem i-frames | Mantém coerência do sistema de colisão |
| Maio/2026 | Stomp válido apenas em morcego isolado | Recompensa precisão; enxame exige outra abordagem |
| Maio/2026 | Feedback de resistência via sprite (sem barra) | HUD limpo; imersivo; coerente com Celeste |
| Junho/2026 | Dois finais determinados pela coleta de lírios | Dá peso real à coleta: define se Eugene cumpre ou não a promessa |
| Junho/2026 | PlayerController implementado como FSM | Controle rigoroso das transições de estado; evita comportamentos indefinidos |
| Junho/2026 | EndingManager como sistema isolado | Separa a lógica de desfecho do resto do jogo; facilita teste e manutenção |

---

## 22. Créditos e Licenças

Código sob licença **MIT**. Assets externos: **CC0** para sprites, **CC-BY** para áudio.

| Recurso | Fonte | Licença | Observação |
|---|---|---|---|
| Código-fonte | Desenvolvido pelo aluno | MIT | Permite uso, cópia, modificação e distribuição |
| Sprites do protagonista | Criados pelo aluno (Aseprite) | Autoral | — |
| Tilesets e assets visuais | A definir (OpenGameArt ou criado) | CC0 | Sem necessidade de atribuição |
| Música e trilha sonora | A definir (asset livre) | CC-BY | Citar o autor na tela de créditos |
| Efeitos sonoros | A definir (freesound.org / Audacity) | CC0 ou CC-BY | Verificar por arquivo; documentar individualmente |

### Sobre as licenças

- **MIT** — para código: uso livre inclusive comercial, exige manter aviso de copyright.
- **CC0** — para sprites/sons: domínio público efetivo. Nenhuma atribuição necessária.
- **CC-BY** — para áudio: uso livre, autor deve ser creditado na tela de créditos.

---

## 23. Reflexão Final

> 📌 Esta seção é tratada como histórico vivo e será atualizada ao longo do desenvolvimento.

### Principais desafios

A ideia de criar um jogo surgiu como algo desafiador — deu medo no início, mas logo abriu caminho para uma sensação de novidade. Ao longo do curso trabalhei com muitos sites e aplicativos, mas nada tão interativo e vivo quanto um jogo. Enxerguei nisso uma oportunidade de experimentar algo que ainda não havia explorado e que poderia agregar muito à minha formação.

### Aprendizados técnicos

Pensar no design do jogo exigiu mais do que eu esperava — há muitas possibilidades a considerar e cada decisão impacta outra. No lado artístico, lidar com pixel art está sendo trabalhoso, mas gratificante: aprendi do zero e sei que ainda estou no básico, o que é natural para quem está começando. O refinamento vem com o tempo e a prática. Quanto à engine, entrar no Godot pela primeira vez foi uma espécie de adrenalina — fazia tempo que eu não sentia aquele tipo de alegria ao experimentar uma ferramenta nova.

### O que faria diferente

Fiquei surpreso com o quão difícil é produzir um bom GDD. Mesmo sendo um trabalho acadêmico, e mesmo sabendo que era esperado um esforço sério, tenho consciência de que este modelo está longe de um GDD profissional. Mas também compreendo que este é meu primeiro jogo, meu primeiro GDD e minha primeira experiência real com desenvolvimento de jogos — e isso significa que imperfeições são parte natural do processo. Há muito espaço para evoluir, e enxergo isso como algo positivo.

### Diagrama de Arquitetura de Software

> 📌 Linha sólida = chamada direta. Linha tracejada = signal (Observer do Godot).

![Diagrama de Arquitetura](https://github.com/user-attachments/assets/bc3e8a24-9bef-405b-b66f-2c35371de0ac)

---

*ONE LAST CLIMB — GDD v1.0 | Felipe da Silva Chawischi | felipe.chawischi@catolica.edu*