# ONE LAST CLIMB
## Game Design Document — v0.8 | Maio/2026

| Campo | Info |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Prototipagem |
| **Versão** | v0.8 |
| **Última atualização** | Maio/2026 |

---

## 1. Visão Geral

### Elevator Pitch

One Last Climb é um jogo de plataforma 2D com movimentação ágil e progressiva, onde o jogador controla Eugene, um velhinho teimoso e determinado. O jogo é divertido primeiro: saltar, dar dash e escalar paredes com precisão é o coração da experiência. A narrativa emocional entra pelas beiradas — nas flores que Eugene coleta pelo caminho e nos sonhos que ele tem nos checkpoints, onde ouve a voz de Liliana. O jogador começa achando que está jogando uma aventura leve de um velhinho cabeçudo. Só lá na frente percebe que estava sendo partido aos poucos.

### Gênero

- **Gênero Principal:** Plataforma 2D
- **Gêneros Secundários:** Aventura, Narrativo

### Público-Alvo

Jogadores casuais e intermediários, principalmente entre adolescentes e adultos (16–35 anos), que apreciam experiências emocionais combinadas com desafios leves a moderados. Também busca atrair jogadores que valorizam narrativa e conexão com personagens.

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

### Liliana — A Esposa

Presente no jogo apenas através das memórias, das flores e das frases que surgem nos sonhos de Eugene nos checkpoints. Nunca aparece diretamente no gameplay — sua presença é construída pela ausência.

- Nome de origem latina (*lilium*) — significa lírio, a flor central do jogo
- Raízes gregas (*Elisábet*) com significado de "meu Deus é um juramento" — ligação simbólica com a promessa do jogo
- Apaixonada por história e literatura, o que justifica as citações latinas e nórdicas que ela deixou na vida de Eugene

---

## 4. Pesquisa e Referências

### Jogos de Referência

#### Celeste (2018) — Maddymakesgames
Plataforma 2D com mecânicas precisas de dash e pulo. O jogo equilibra dificuldade elevada com uma narrativa emocional sobre saúde mental.
- Inspira: estrutura de ensino de mecânicas por fase (mostrar → misturar → desafiar), feedback visual e sonoro de qualidade, coexistência entre desafio e narrativa emocional.

#### Hollow Knight (2017) — Team Cherry
Plataforma 2D com atmosfera subterrânea densa e uso expressivo de iluminação pontual em ambientes escuros.
- Inspira: design da zona de caverna, uso de luz pontual em fundo escuro para criar atmosfera subterrânea, personagens pequenos que comunicam emoção por postura e animação.

#### A Short Hike (2019) — adamgryu
Jogo de exploração casual onde o jogador sobe uma montanha no próprio ritmo.
- Inspira: progressão por terrenos abertos e desafiadores, ritmo contemplativo, sensação de liberdade ao atingir o cume.

### Mood Board

> 📌 Ver imagem: `docs/moodboard.png`

### Análise das Referências

| Jogo | O que faz bem | O que inspirou |
|---|---|---|
| Celeste | Ensino de mecânicas integrado ao level design | Estrutura mostrar → misturar → desafiar por fase |
| Hollow Knight | Atmosfera subterrânea com iluminação pontual | Design da caverna; expressão emocional via sprite pequeno |
| A Short Hike | Progressão orgânica; ritmo contemplativo | Estrutura de subida de montanha; conquista no cume |

---

## 5. Hipóteses de Design

| Hipótese | Como será testada |
|---|---|
| Jogadores se conectam emocionalmente com personagens idosos | Playtest com público diverso, coleta de feedback qualitativo |
| Lírios coletados incentivam exploração | Observação em playtest: jogadores exploram ou ignoram as flores? |
| A estrutura mostrar→misturar→desafiar ensina as mecânicas sem tutorial explícito | Medir tentativas e erros por fase; jogador entende o que fazer? |
| Sonhos nos checkpoints reforçam a narrativa sem interromper o ritmo | Perguntar no playtest se os sonhos foram percebidos como intrusivos ou emocionantes |
| Tom leve potencializa o impacto emocional dos momentos narrativos | Medir reação emocional em playtest: o contraste leve/pesado funciona? |

### Pilares do Jogo

- **Gameplay divertido primeiro** — o jogo precisa ser prazeroso de jogar antes de qualquer mensagem emocional. Movimento ágil, responsivo e satisfatório é a base de tudo.
- **Leveza como veículo da emoção** — o jogo trata de assuntos sérios (luto, perda, promessa) através de uma superfície leve e bem-humorada. O impacto emocional é maior justamente porque o jogador foi pego de surpresa. Referência direta à "tática Disney".
- **Progressão orgânica** — cada fase ensina, mistura e desafia. O jogador domina as mecânicas pelo level design, não por texto.
- **Contemplação e descoberta** — o ambiente recompensa quem explora, sem forçar o ritmo.

---

## 6. Gameplay

### Core Loop

O núcleo do jogo é o movimento: pular, dar dash e escalar paredes é o que o jogador faz a maior parte do tempo, e precisa ser divertido por si só. A narrativa entra como recompensa — nos checkpoints (sonhos de Liliana) e nos lírios coletados (que formam o álbum de memórias).

> Explorar a fase → superar obstáculos de plataforma → ativar checkpoint → Eugene dorme → ouve a voz de Liliana → resmuga ao acordar → avançar para a próxima seção → repetir

### Loops Secundários

- Coletar todos os lírios da fase para completar o álbum de memórias
- Dominar o encadeamento das habilidades de movimentação

### Mecânicas Principais

Todas as habilidades estão disponíveis desde o início. O level design de cada fase é responsável por apresentar, misturar e desafiar o jogador com cada mecânica progressivamente.

| Mecânica | Descrição |
|---|---|
| Pulo simples | Responsivo e preciso — base de toda a movimentação. |
| Pulo duplo | Segundo pulo no ar para alcançar plataformas mais altas. Abre novas possibilidades de rota. |
| Dash | Impulso horizontal rápido e satisfatório. **Não possui i-frames** — qualquer contato com inimigo durante o dash causa dano normalmente. |
| Wall jump | Saltar entre paredes em sequência rápida. Mecânica que exige timing e recompensa o domínio. |
| Escalada | Agarrar e subir superfícies verticais. Possui limite de resistência: quando esgotado, Eugene começa a tremer e escorrega até cair. O feedback é visual no próprio sprite (tremor e leve mudança de cor) — sem barra explícita no HUD, referência direta ao estilo de Celeste. |

### Câmera

Câmera lateral 2D com scroll automático suave seguindo o personagem. Pequenos offsets verticais antecipam plataformas acima. Em momentos de sonho (checkpoint), a tela escurece suavemente antes de exibir a fala de Liliana.

### Sistemas

**Vitória:** Eugene chega ao topo da montanha e realiza o ritual de homenagem a Liliana, espalhando as cinzas no cume — desencadeando a cena final.

**Derrota:** Contato com inimigos ou quedas em abismos. Eugene é reposicionado imediatamente no último checkpoint ativado, sem nenhuma interrupção narrativa — o respawn é silencioso para preservar o ritmo da gameplay.

**Progressão:** A cada checkpoint ativado **pela primeira vez**, Eugene dorme e o sonho de Liliana é exibido. Nas mortes subsequentes, o respawn é direto — o sonho não se repete. Os lírios coletados ficam registrados no álbum de memórias.

---

## 7. Sistema de Sonhos e Checkpoints

Esta é a mecânica que conecta gameplay e narrativa. O movimento é interrompido brevemente por um sonho — e retomado com Eugene um pouco mais inteiro.

### Como funciona

1. Eugene ativa um checkpoint (fogueira ou sinal de descanso)
2. **Na primeira ativação:** a tela escurece suavemente, Eugene dorme, a voz de Liliana fala uma frase, Eugene resmuga ao acordar
3. **Nas ativações seguintes (respawn após morte):** o reposicionamento é imediato e silencioso — o sonho não se repete
4. O jogo retoma normalmente do ponto do checkpoint

> 📌 Esta regra é essencial para preservar o ritmo ágil da gameplay. Morrer repetidas vezes em uma mesma fase não força o jogador a rever o mesmo diálogo.

### Falas por Checkpoint

> As frases não são citações acadêmicas — são Eugene lembrando, do jeito dele, de algo que Liliana dizia. Tom leve, afetivo, às vezes com humor involuntário de velho teimoso.

| # | Checkpoint | Fala de Liliana (no sonho) | Resmungo de Eugene |
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
| Durante a escalada (geral) | *"Por você minha querida, qualquer coisa."* |
| Ao chegar ao topo | *"Reunidos em breve."* |

---

## 8. Estrutura das Fases

O jogo possui 5 fases, representando trechos progressivos da escalada de Eugene. Cada fase segue uma estrutura de três partes inspirada no design da Nintendo para Mario: a Parte 1 apresenta a mecânica principal da fase, a Parte 2 mistura ou aumenta a dificuldade, e a Parte 3 traz o desafio consolidado. Plataformas estão presentes em todas as fases como mecânica base.

### Fase 1 — Base da montanha (floresta e trilha inicial)

*Tom narrativo: introdução leve. Eugene começa reclamando da subida.*

| Parte | Descrição |
|---|---|
| Parte 1 | Tutorial integrado ao gameplay, no estilo Celeste: o próprio level design ensina os controles sem texto excessivo. |
| Parte 2 | Eugene se depara com uma placa bloqueando o caminho oficial. Motivado pela promessa, decide seguir pela entrada da mina. |
| Parte 3 | Entrada na caverna. Ambiente escurece. Desafio único de plataforma sem inimigos — apresenta o tom do que virá. |

### Fase 2 — Entrada da caverna (pedras e raízes)

*Tom narrativo: transição. O caminho começa a pesar, mas Eugene ainda faz piada.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e morcegos simples. Apresenta o inimigo e seu padrão de patrulha. |
| Parte 2 | Plataformas e mais morcegos. O volume aumenta e os posicionamentos ficam mais desafiadores. |
| Parte 3 | Plataformas e enxame de morcegos. Desafio consolidado do inimigo principal da fase. |

### Fase 3 — Caverna profunda

*Tom narrativo: o humor diminui. As memórias ficam mais pesadas.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e estalagmites. Apresenta o novo obstáculo e seu comportamento de vibração e queda. |
| Parte 2 | Plataformas e mais estalagmites em combinações mais complexas. |
| Parte 3 | Tudo junto: morcegos, estalagmites e uma grande subida vertical. O jogador escala um túnel vertical estilo poço de elevador, preenchido com plataformas flutuantes penduradas em cordas — o visual lembra um elevador de mina abandonado. Esse momento conecta visualmente com a Fase 4 e transmite sensação de progresso real. |

### Fase 4 — Caverna densa (ponto mais difícil do jogo)

*Tom narrativo: momento mais sombrio. Eugene para de falar. Só continua.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e plataformas penduradas em corda (sem chão firme). O jogador continua o sistema da subida da Fase 3, agora como ambiente principal. |
| Parte 2 | Plataformas penduradas com estalagmites — exige timing preciso para desviar enquanto se movimenta em terreno instável. |
| Parte 3 | Tudo junto e na dificuldade máxima. Combinação de plataformas penduradas, estalagmites e morcegos. Ponto de maior pressão do jogo. |

### Fase 5 — Caverna clareando → cume

*Tom narrativo: alívio. A luz volta. Eugene chora — mas chega.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e estalagmites. O ambiente já clarea levemente — o fim está próximo. |
| Parte 2 | Igual à Parte 1, porém com dificuldade aumentada. A luz continua crescendo. |
| Parte 3 | Mais difícil ainda — e na saída da caverna, um enxame de morcegos aparece de surpresa. Um susto final: ainda pode matar, mas o céu aberto já é visível ao fundo. |
| Parte 4 (Cena Final) | Eugene sai da mina e chega ao topo. Cena narrativa: espalha as cinzas de Liliana. Jogo concluído. |

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
- Plataformas móveis e plataformas penduradas em cordas (fases 3, 4 e 5)
- Trechos de parede para wall jump obrigatório

---

## 10. Escopo do Projeto

### O jogo inclui

- 5 fases distintas representando trechos da montanha, cada uma com 3 partes (+ cena final na Fase 5)
- 4 mecânicas de movimentação disponíveis desde o início (pulo, pulo duplo, dash, wall jump) + escalada
- 5 sonhos narrativos nos checkpoints (tela preta + fala de Liliana + resmungo de Eugene)
- Sistema de lírios colecionáveis e álbum de memórias
- 2 tipos de inimigo: morcego e estalagmite instável
- Menu principal, pausa e tela de game over
- Trilha sonora e efeitos sonoros
- Sistema de save local

### O jogo não inclui

- Multiplayer
- Sistema de crafting ou inventário
- Geração procedural de fases
- Localização para outros idiomas (somente português)
- Sistema de save em nuvem

---

## 11. Prototipagem

| Protótipo | Objetivo | Resultado |
|---|---|---|
| Movimentação básica | Validar pulo e movimentação lateral no Godot | A preencher |
| Pulo duplo | Testar sensibilidade e feel | A preencher |
| Dash | Testar sensibilidade e feel do dash | A preencher |
| Wall jump | Testar sensibilidade e feel do salto de parede | A preencher |
| Escalada | Validar agarrar e subir superfícies verticais | A preencher |
| Sistema de sonho (checkpoint) | Validar tela preta + fala + resmungo | A preencher |
| Inimigo morcego | Testar lógica de patrulha e dano por contato | A preencher |
| Estalagmite instável | Testar gatilho de queda e dano | A preencher |

---

## 12. Interface (UI/UX)

### HUD

- **Indicador de resistência na escalada** — sem barra explícita. O feedback é dado pelo próprio sprite de Eugene: ele começa a tremer e sofre leve mudança de cor conforme se aproxima do limite. Ao esgotar, escorrega e cai.
- Indicador discreto de flores coletadas na fase atual (canto superior direito)
- HUD completamente oculto durante os sonhos nos checkpoints

### Menus

- **Menu principal:** Jogar, Continuar, Opções, Sair
- **Menu de pausa:** Retomar, Álbum de Memórias, Opções, Menu Principal
- **Game over:** mensagem curta + botões Tentar Novamente / Menu Principal
- **Opções:** Controles (remapeável), Áudio (Geral / Música / SFX), Vídeo (Fullscreen, V-Sync, UI)

### Flow de Telas

> 📌 Ver imagem: `docs/menu_flow.png`

```
Menu Principal → Jogar → Fase ativa ←→ [Pausa] → Retomar ou Menu Principal
                                     → [Sonho/Checkpoint] → retorna à fase
                                     → [Game Over] → Tentar novamente ou Menu Principal
```

### Wireframes

> 📌 Ver imagem: `docs/wireframe.png`

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

Pixel art com resolução base 320×180, ampliada em múltiplos inteiros (upscale) para manter pixels nítidos. Personagens ~16×16 px, tilesets 8×8 px. Filtro Nearest no Godot para evitar borramentos.

### Paleta de Cores — Jornada do Jogador

> 📌 Ver imagem: `docs/palette.png`

#### Floresta Inicial — calma e natural
*Sensação: natureza, tranquilidade, começo da aventura.*

| Papel | Cor | Hex |
|---|---|---|
| Dominante | Verde floresta | `#4A7C3F` |
| Verde médio | — | `#7AAD5A` |
| Secundária | Marrom terra | `#7B4F28` |
| Destaque | Azul céu | `#5A7A8C` |

#### Mina — fria, escura, claustrofóbica
*Sensação: ambiente frio, escuridão, tensão, exploração.*

| Papel | Cor | Hex |
|---|---|---|
| Dominante | Cinza escuro | `#2A3040` |
| Pedra média | — | `#3D4A5C` |
| Secundária | Cinza médio | `#4A5060` |
| Destaque claro | Ciano mineral | `#1ECFC0` |
| Lanterna âmbar | — | `#EFA827` |
| Perigo/lava | — | `#E84A4A` |

#### Topo da Montanha — quente, livre, acolhedor
*Sensação: liberdade, ar livre, ambiente mais quente.*

| Papel | Cor | Hex |
|---|---|---|
| Dominante | Verde vivo | `#5AAD3C` |
| Secundária | Amarelo sol | `#E8A820` |
| Luz dourada | — | `#F4CC60` |
| Destaque céu | Azul claro | `#60B4E8` |
| Pôr do sol | — | `#D07848` |

### Referências Visuais

- **Celeste** — pixel art expressivo, fundos de montanha com paralaxe, uso emocional de cor
- **Hollow Knight** — atmosfera subterrânea com iluminação pontual em ambiente escuro
- **Carl (UP, Pixar)** — referência estética para o protagonista: postura curvada e expressão fechada comunicam idade e determinação

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
| Música ambiente (presente) | Fases jogadas | Sim | Piano e cordas suaves, melancolia serena |
| Música de sonho | Checkpoints — tela preta | Não | Tema nostálgico, mais quente e aconchegante |
| Trilha de tensão | Proximidade de inimigos | Sim | Elevação sutil de tensão, sem ser agressiva |
| SFX pulo | A cada pulo | Não | Som leve, sem peso excessivo |
| SFX dash | Ao usar o dash | Não | Whoosh curto e preciso |
| SFX coleta de flor | Ao pegar o lírio | Não | Nota musical suave e positiva |
| SFX dano | Ao sofrer dano | Não | Impacto leve, sem ser brutal |
| SFX checkpoint | Ao ativar checkpoint | Não | Som reconfortante, sensação de segurança |

---

## 15. Animação

| Animação | Personagem/Objeto | Loop? | Descrição |
|---|---|---|---|
| Idle | Eugene | Sim | Respiração suave, leve balanço |
| Caminhar | Eugene | Sim | Passo cadenciado, posição levemente curvada de idoso |
| Pulo | Eugene | Não | Subida e descida com frames distintos |
| Pulo duplo | Eugene | Não | Segundo pulo com efeito visual distinto do primeiro |
| Dash | Eugene | Não | Frames rápidos com trilha de partículas |
| Wall slide | Eugene | Sim | Corpo raspando a parede |
| Escalada | Eugene | Sim | Movimento de subida em superfície vertical |
| Dano | Eugene | Não | Flash e recuo rápido |
| Dormir (checkpoint) | Eugene | Sim | Eugene fecha os olhos e a tela escurece |
| Idle patrulha | Morcego | Sim | Movimento lateral de patrulha |
| Ataque | Morcego | Não | Avanço em linha reta ao detectar Eugene |
| Vibração | Estalagmite | Sim | Tremor crescente antes de cair |
| Queda | Estalagmite | Não | Queda vertical |
| Flutuação | Lírio (item) | Sim | Balanço suave com brilho pulsante |

---

## 16. Arquitetura de Software

O projeto será estruturado em Godot 4 com GDScript, seguindo separação de responsabilidades por scripts e uso de Autoloads para sistemas globais.

- `GameManager` *(Autoload)* — controla estado global, transições de cena e progresso do jogador
- `PlayerController` — input, física e animações de Eugene
- `EnemyBase` — classe base para comportamento de inimigos (morcego, estalagmite)
- `CheckpointSystem` — gerencia ativação de checkpoints e disparo dos sonhos
- `FlowerSystem` — gerencia coleta de lírios e álbum de memórias
- `UIManager` — controla HUD, menus e transições de tela
- `AudioManager` *(Autoload)* — reproduz e mistura músicas e efeitos sonoros

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

| Data | Participantes | Principais problemas |
|---|---|---|
| A preencher | A preencher | A preencher após realização dos playtests |

### Melhorias Implementadas

> A preencher após os ciclos de playtest.

---

## 18. Cronograma

| Milestone | Período previsto | Descrição |
|---|---|---|
| Pesquisa e GDD | Março – Maio/2026 | Documentação, referências, conceito e reestruturações de design |
| Protótipo de movimentação | Maio – Junho/2026 | Todas as mecânicas jogáveis: pulo duplo, dash, wall jump, escalada |
| Fase 1 jogável | Junho/2026 | Arte, level design (3 partes) e primeiro sonho integrados |
| Fases 2 e 3 | Julho/2026 | Inimigos, plataformas penduradas e sistema de sonhos |
| Fases 4 e 5 | Agosto/2026 | Conclusão do conteúdo principal, cena final e áudio |
| Polimento e playtests | Setembro/2026 | Ajustes de dificuldade, bugs, UI e álbum de memórias |
| Build final + entrega | Outubro/2026 | Versão final para avaliação |

---

## 19. Riscos do Projeto

| Risco | Impacto | Mitigação |
|---|---|---|
| Escopo de arte muito grande | Atraso na produção | Limitar assets; reutilizar sprites com variações de cor e flip |
| Level design de 5 fases (3 partes cada) muito trabalhoso | Escopo inflado | Priorizar Fases 1–3 como núcleo; 4 e 5 como expansão controlada |
| Narrativa emocional não ressoar | Jogo perde identidade | Playtest cedo com foco em feedback emocional |
| Performance no WebGL | Experiência ruim no navegador | Testar build web desde as fases iniciais |
| Falta de tempo para polimento | Entrega com bugs | Buffer de 2 semanas reservado antes da entrega |
| Assets de áudio com licenças incompatíveis | Problemas de distribuição | Usar apenas CC0 e CC-BY; documentar tudo na seção de créditos |

---

## 20. Limitações Conhecidas

- Multiplayer não será implementado
- Sistema de save em nuvem fora do escopo (save local)
- Localização apenas em português
- Arte criada pelo aluno: qualidade sujeita a evolução durante o projeto
- Suporte apenas a teclado (sem gamepad nesta versão)

---

## 21. Decisões Importantes

| Data | Decisão | Motivo |
|---|---|---|
| Abril/2026 | Pixel art como estilo visual | Domínio da ferramenta (Aseprite); coerente com as referências |
| Abril/2026 | Godot 4 como engine | Open source, leve, excelente exportação WebGL, GDScript acessível |
| Abril/2026 | 5 fases como escopo | Equilíbrio entre conteúdo satisfatório e viabilidade para TCC solo |
| Abril/2026 | Fase 5 sem inimigos até a saída | Metáfora intencional: o caminho final é de contemplação; o enxame final é um susto narrativo |
| Abril/2026 | Tom leve na superfície, emoção pesada por baixo (tática Disney) | O impacto emocional é maior quando o jogador é pego de surpresa |
| Maio/2026 | Flashbacks substituídos por sonhos nos checkpoints | Mais imersivo; elimina cenas estáticas desenhadas (escopo menor); tela preta é mais direta emocionalmente |
| Maio/2026 | Lírios como colecionáveis puros (sem recompensa definida) | Separa recompensa narrativa (checkpoints) da exploração (álbum). Recompensa por 100% em aberto: caso o tempo permita, será implementado um segundo final para quem completar o buquê. |
| Maio/2026 | Todas as habilidades disponíveis desde o início | O level design ensina as mecânicas organicamente; o jogador não é bloqueado artificialmente |
| Maio/2026 | Estrutura de 3 partes por fase (estilo Nintendo) | Apresenta, mistura e desafia de forma clara; facilita o level design e o ensino das mecânicas |
| Maio/2026 | Suporte apenas a teclado | Foco no escopo; simplifica controles e testes |
| Maio/2026 | Sonho exibido apenas na primeira ativação do checkpoint | Respawn silencioso preserva o ritmo ágil; morrer repetidamente não força rever o mesmo diálogo |
| Maio/2026 | Dash sem i-frames | Mantém coerência do sistema de colisão; o dash não funciona como escape garantido de inimigos |
| Maio/2026 | Stomp válido apenas em morcego isolado | Recompensa precisão e leitura de cenário; enxame é ameaça distinta que exige outra abordagem |
| Maio/2026 | Feedback de resistência da escalada via sprite (sem barra) | HUD limpo; feedback integrado ao personagem é mais imersivo, coerente com o estilo de Celeste |

---

## 22. Créditos e Licenças

O código do projeto é distribuído sob a licença **MIT**. Assets externos seguem suas próprias licenças, priorizando **CC0** para sprites e **CC-BY** para áudio.

| Recurso | Fonte | Licença | Observação |
|---|---|---|---|
| Código-fonte | Desenvolvido pelo aluno | MIT | Permite uso, cópia, modificação e distribuição |
| Sprites do protagonista | Criados pelo aluno (Aseprite) | Autoral | — |
| Tilesets e assets visuais | A definir (OpenGameArt ou criado) | CC0 | Sem necessidade de atribuição |
| Música e trilha sonora | A definir (asset livre) | CC-BY | Citar o autor na tela de créditos |
| Efeitos sonoros | A definir (freesound.org / Audacity) | CC0 ou CC-BY | Verificar por arquivo; documentar individualmente |

### Sobre as licenças usadas

- **MIT** — para código: permite uso livre, inclusive comercial, exigindo apenas manutenção do aviso de copyright.
- **CC0** — para sprites e sons: domínio público efetivo. Nenhuma atribuição necessária. Ideal para assets de uso rápido.
- **CC-BY** — para áudio: permite uso livre desde que o autor seja creditado. Incluir nome do compositor na tela de créditos do jogo.

---

## 23. Reflexão Final

> ⏳ Esta seção deve ser preenchida ao final do projeto, após a entrega da versão final.

**Principais desafios:** a preencher.

**Aprendizados técnicos:** a preencher.

**O que faria diferente:** a preencher.

---
