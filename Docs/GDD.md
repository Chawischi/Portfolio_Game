# ONE LAST CLIMB
## Game Design Document — v1.1 | Setembro/2026

| Campo | Info |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Prototipagem avançada |
| **Versão** | v1.1 |
| **Última atualização** | Setembro/2026 |

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
| Instruções de execução | Godot 4.x \| Windows 10+ \| Teclado e Controle |

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
| Lírios recompensam atenção ao cenário, mesmo em um percurso linear | Observação direta: registrar se jogadores buscam ou ignoram as flores | 60% notam e coletam o lírio disponível em cada fase sem instrução explícita |
| Estrutura mostrar→misturar→desafiar ensina sem tutorial explícito | Medir tentativas até completar cada parte da fase | 90% completam a Parte 1 da Fase 1 em até 3 tentativas |
| Sonhos nos checkpoints não interrompem o ritmo | Perguntar pós-sessão se os sonhos foram intrusivos ou emocionantes | Menos de 20% relatam os sonhos como intrusivos |
| Tom leve potencializa impacto emocional | Registrar reações verbais e expressões durante a cena final | 50% demonstram reação emocional notável na cena do cume |

> 📌 As hipóteses ainda não foram validadas formalmente com playtesters — a validação está prevista para o período de playtest de outubro/2026.

### Pilares do Jogo

- **Gameplay divertido primeiro** — movimento ágil, responsivo e satisfatório é a base de tudo.
- **Leveza como veículo da emoção** — assuntos sérios embalados com superfície leve (tática Disney).
- **Progressão orgânica** — cada fase ensina, mistura e desafia pelo level design.
- **Contemplação e descoberta** — o ambiente recompensa quem explora.

---

## 6. Gameplay

### Core Loop

O núcleo do jogo é o movimento. A narrativa entra como recompensa — nos checkpoints (sonhos de Liliana) e nos lírios coletados (álbum de memórias).

> Avançar pela fase superando obstáculos → ativar checkpoint → Eugene dorme → ouve Liliana → resmuga ao acordar → continuar avançando → repetir

### Loops Secundários

- Coletar todos os lírios da fase para completar o buquê e desbloquear o **Final Verdadeiro**
- Dominar o encadeamento das habilidades de movimentação

### Mecânicas Principais

Todas as habilidades estão disponíveis desde o início. O level design apresenta, mistura e desafia progressivamente.

| Mecânica | Descrição |
|---|---|
| Pulo simples | Responsivo e preciso — base de toda a movimentação. |
| Pulo duplo | Segundo pulo no ar para alcançar plataformas mais altas. |
| Dash | Impulso **omnidirecional** (8 direções), com curva de aceleração e desaceleração calculada matematicamente a partir de distância e duração desejadas, preservação parcial de momentum ao final e efeito visual de rastro. **Não possui i-frames** — qualquer contato com inimigo durante o dash causa dano normalmente. |
| Wall jump | Saltar entre paredes em sequência rápida. O impulso é sempre numa diagonal fixa, para longe da parede — não lê direção do jogador, mantendo o desafio focado no timing. Exige timing e recompensa o domínio. |
| Escalada | Agarrar e subir superfícies verticais através de um **botão dedicado** (não é automática por proximidade). Possui limite de resistência: quando esgotado, Eugene começa a tremer e escorrega até cair. O feedback é visual no sprite (tremor e leve mudança de cor), sem barra explícita no HUD. |

### Mockups das Mecânicas

![Mockup — Mecânica de andar](https://github.com/user-attachments/assets/6ea9627d-c101-4f3a-b059-066fa60b57be)

![Mockup — Mecânica de pulo](https://github.com/user-attachments/assets/eba0fdc3-3983-4de7-ae82-c294b752d013)

![Mockup — Mecânica de pulo duplo](https://github.com/user-attachments/assets/026e3c85-4339-4ea3-96d2-3867a73ee955)

![Mockup — Mecânica de dash](https://github.com/user-attachments/assets/d8fffd32-e05a-472c-9430-762663d4359f)

![Mockup — Mecânica de escalar](https://github.com/user-attachments/assets/6dd31a5c-7f5b-4193-8075-3d343bfa5471)

![Mockup — Mecânica de wall jump](https://github.com/user-attachments/assets/171caa12-c121-438d-b966-d0c64e30e4c3)

### Câmera

Lateral 2D com scroll suave, seguindo o player via câmera desacoplada. Offsets verticais antecipam plataformas acima.

### Sistemas

**Vitória — Dois Finais**

O desfecho do jogo é determinado pela coleta dos lírios ao longo das fases:

| Final | Condição | O que acontece |
|---|---|---|
| **Final Verdadeiro (Feliz)** | Jogador coletou todos os lírios e completou o buquê | Eugene chega ao topo, realiza o ritual completo e espalha as cinzas com o buquê. Cena de encerramento emocionante e reconfortante. |
| **Final Trágico** | Jogador não coletou todos os lírios | Eugene chega ao topo, mas antes de completar o ritual sofre um ataque do coração e cai. Morre no cume sem cumprir a promessa — sozinho, sem o buquê, sem o ritual. |

> 📌 A existência de dois finais dá peso real à coleta dos lírios: não é opcional, é a diferença entre Eugene cumprir ou não a sua última promessa.

**Derrota:** Contato com inimigos ou queda em abismo reposiciona o jogador no ponto de respawn mais próximo dentro do trecho atual, de forma silenciosa e sem interrupção narrativa — não necessariamente no último checkpoint ativado. *(Ver Seção 7 para a distinção entre pontos de respawn e checkpoints narrativos.)*

**Progressão:** A cada checkpoint ativado **pela primeira vez**, Eugene dorme e o sonho de Liliana é exibido. Nas ativações seguintes, apenas a marcação de progresso é atualizada — o sonho não se repete.

---

## 7. Sistema de Sonhos e Checkpoints

Esta é a mecânica que conecta gameplay e narrativa.

### Como funciona

1. Ao se aproximar de um checkpoint (acampamento), surge um indicativo de interação.
2. Pressionando o botão de interagir, Eugene se senta, e o controle do jogador é temporariamente bloqueado.
3. **Na primeira ativação daquele checkpoint específico:** a tela escurece suavemente, e o texto do sonho aparece progressivamente (efeito de digitação), com a fala da Liliana seguida do resmungo de Eugene ao acordar; a tela então clareia novamente e o controle é devolvido ao jogador.
4. **Nas ativações seguintes do mesmo checkpoint:** a sequência de sentar/levantar se repete, mas o sonho não é mostrado novamente — apenas a marcação de progresso é atualizada.

> 📌 Esta regra preserva o ritmo ágil da gameplay. Morrer repetidas vezes não força o jogador a rever o mesmo diálogo.

> **Nota de esclarecimento:** morte por queda ou contato com hazard/inimigo reposiciona o jogador no ponto de respawn mais próximo dentro do trecho atual (silencioso, sem qualquer narrativa) — não necessariamente no último checkpoint/acampamento ativado. Os checkpoints narrativos descritos nesta seção representam pontos de descanso mais espaçados, associados à progressão da história e, futuramente, ao sistema de salvamento.

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

5 fases representando trechos progressivos da escalada. Plataformas flutuantes (sem cordas ou suportes visíveis) estão presentes nas fases 2, 3, 4 e 5.

### Wireframe de Level Design

![Wireframe de Level Design](https://github.com/user-attachments/assets/ba65cb95-a63e-47c9-bdfa-bc1521ceacb5)

### Layout — Zona 1 (Fase 1)

![Layout Zona 1](https://github.com/user-attachments/assets/caf47c73-be4d-46f4-b21c-40a685f94c47)

### Fase 1 — Base da montanha (floresta e trilha inicial)
*Tom: introdução leve. Eugene começa reclamando da subida.*

| Parte | Descrição |
|---|---|
| Parte 1 | Tutorial integrado ao gameplay no estilo Celeste: o level design ensina os controles sem texto excessivo. |
| Parte 2 | Eugene se depara com uma placa bloqueando o caminho oficial. Decide seguir pela entrada da mina, dando início à sua jornada de verdade. |

> 📌 Diferente das demais fases (estruturadas em 3 partes), a Fase 1 é composta por apenas 2 partes, já que seu papel é estritamente introdutório (tutorial + gancho narrativo), sem necessidade de uma terceira parte de consolidação de desafio.

### Fase 2 — Entrada da caverna
*Tom: transição. O caminho começa a pesar, mas Eugene ainda faz piada.*

| Parte | Descrição |
|---|---|
| Parte 1 | Plataformas e morcegos simples. Apresenta o inimigo e seu padrão de patrulha. |
| Parte 2 | Plataformas e mais morcegos. Volume aumenta e posicionamentos ficam desafiadores. |
| Parte 3 | Plataformas e morcegos em maior densidade, consolidando o desafio do inimigo principal da fase. |

### Fase 3 — Caverna profunda
*Tom: o humor diminui. As memórias ficam mais pesadas. Estrutura diferenciada: a fase é majoritariamente composta por uma sequência de fuga (run), na qual o jogador precisa avançar continuamente sob pressão de tempo, fugindo de um enxame que preenche a tela atrás dele.*

| Parte | Descrição |
|---|---|
| Parte 1 | Introdução às estalagmites, em ritmo calmo, ensinando a mecânica antes da pressão da fuga começar. |
| Parte 2 | Uma armadilha narrativa desencadeia o início da perseguição: o enxame surge, forçando o início do run. |
| Parte 3 | Sequência de fuga contínua, combinando obstáculos de plataforma e estalagmites com a pressão constante do enxame avançando. |

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
| Morcego (sozinho) | 2, 4 | Patrulha lateral no ar dentro de uma área delimitada; ao detectar o jogador, exibe um breve indicativo visual de alerta antes de avançar em linha reta na direção detectada | Pular em cima **elimina** o morcego sem causar dano (stomp). Contato lateral causa dano. |
| Enxame de morcegos | 3, 5 | Sequência de fuga: uma "parede" representando o enxame avança continuamente, forçando o jogador a se manter à frente dela | Nenhuma forma de stomp válida — **qualquer contato causa dano/reinício da sequência.** |
| Estalagmite instável | 3, 4, 5 | Estática no teto; vibra ao se aproximar, cai após alguns segundos | Causa dano em **qualquer contato**, tanto presa no teto quanto durante a queda. |

### Regras Gerais de Colisão

- O **dash não possui i-frames** — qualquer contato com inimigo durante o dash causa dano normalmente.
- **Stomp** (pular em cima) funciona apenas em morcegos isolados, nunca no enxame.
- A estalagmite causa dano em qualquer contato, esteja ela presa no teto ou caindo — não há momento seguro para tocá-la.

### Obstáculos Ambientais

- Abismos entre plataformas
- Plataformas flutuantes (sem cordas ou suportes visíveis), presentes nas fases 2, 3, 4 e 5
- Trechos de parede para wall jump obrigatório

---

## 10. Escopo do Projeto

### O jogo inclui

- 5 fases (a Fase 1 estruturada em 2 partes; as demais em 3 partes cada, + cena final na Fase 5)
- 4 mecânicas de movimentação + escalada, todas disponíveis desde o início
- 5 sonhos narrativos nos checkpoints (tela preta + fala de Liliana + resmungo de Eugene)
- Sistema de lírios colecionáveis que determina o final obtido
- **Dois finais:** Final Verdadeiro (coleta completa) e Final Trágico (coleta incompleta)
- 2 tipos de inimigo (morcego e estalagmite instável) + sequência de fuga do enxame de morcegos (fases 3 e 5)
- Menu principal, pausa e opções (incluindo remapeamento de controles)
- Efeito de transição visual em momentos de morte/respawn, ao invés de uma tela tradicional de game over
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
| Movimentação básica | Validar pulo e movimentação lateral | ✅ Testado e validado |
| Pulo duplo | Testar sensibilidade e feel | ✅ Testado e validado |
| Dash | Testar sensibilidade e feel | ✅ Testado e validado (reformulado, omnidirecional) |
| Wall jump | Testar sensibilidade e feel | ✅ Testado e validado |
| Escalada | Validar agarrar e subir superfícies | ✅ Testado e validado (botão dedicado) |
| Interação com checkpoint (sentar/levantar) | Validar timing e clareza da interação | 🔶 Em processo (lógica pronta, aguardando arte final) |
| Sonho (checkpoint) | Validar tela preta + fala + resmungo | ✅ Testado e validado |
| Inimigo morcego | Testar patrulha e dano por contato | ✅ Testado e validado |
| Estalagmite instável | Testar gatilho de queda e dano | ⏳ Não iniciado |
| Enxame de morcegos (sequência de fuga) | Testar pressão de tempo e clareza do desafio | 🔶 Em processo |
| Sistema de dois finais | Validar verificação de lírios e disparo do final correto | ⏳ Parcialmente pronto (contagem de flores implementada; ramificação de final ainda não) |

---

## 12. Interface (UI/UX)

### HUD

- **Indicador de resistência na escalada** — sem barra explícita. O feedback é dado pelo sprite de Eugene: ele começa a tremer e sofre leve mudança de cor. Ao esgotar, escorrega e cai.
- Indicador de flores coletadas na fase (canto superior direito), exibindo a contagem atual sobre o total daquela fase
- HUD oculto durante os sonhos nos checkpoints

### Menus

- **Menu principal:** Jogar, Continuar (habilitado somente após implementação do sistema de save), Opções, Sair
- **Menu de pausa:** Retomar, Opções, Menu Principal
- **Morte/Respawn:** sem tela dedicada de game over. Ao morrer, um efeito visual de transição (íris fechando e reabrindo) marca o momento do respawn, mantendo o ritmo do jogo sem interromper com uma tela separada.
- **Opções:** Controles (remapeável, teclado e controle), Áudio (Geral/Música/SFX), Vídeo (Fullscreen/V-Sync). Escala de UI planejada, ainda não implementada.

### Flow de Telas

![Flow de Telas](https://github.com/user-attachments/assets/260b08ea-f710-410a-8623-0306814205b1)

### Wireframes de Menus e HUD

![Wireframes](https://github.com/user-attachments/assets/0f26a289-6896-4fc0-b050-fc4cba5ee644)

### Controles — Teclado e Controle

| Ação | Teclado | Controle |
|---|---|---|
| Mover | A / D ou setas | Analógico esquerdo / D-Pad |
| Pular / Pulo duplo | Espaço / W / seta cima | Botão A / Cross |
| Dash | E ou Shift + direcional | Gatilho (LT ou RT, configurável) |
| Escalada | Aproximar da superfície + direcional (botão dedicado) | Gatilho (LT ou RT, configurável) |
| Wall jump | Pulo, pressionado ao encostar na parede | Botão A / Cross, pressionado ao encostar na parede |
| Interagir (checkpoint, placas) | E | Botão Triângulo / Y |
| Pausar | Esc | Botão Start / Options |

> **Nota:** o mapeamento exato de teclas e botões de controle (incluindo dash, escalada e demais ações) ainda está sujeito a ajustes finais antes da entrega, tanto no teclado quanto no controle. O sistema de remapeamento já permite qualquer configuração personalizada em ambos os dispositivos.

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
| Escalada | Eugene | Sim | Movimento de subida em superfície vertical |
| Tremor (resistência baixa) | Eugene | Sim | Tremor e leve mudança de cor ao se aproximar do limite |
| Dano | Eugene | Não | Flash e recuo rápido |
| Sentar (checkpoint) | Eugene | Não | Eugene se senta ao interagir com o checkpoint — *placeholder atual: reaproveita `idle`* |
| Levantar (checkpoint) | Eugene | Não | Eugene se levanta ao final da sequência — *placeholder atual: reaproveita `idle`* |
| Queda (Final Trágico) | Eugene | Não | Eugene cai no cume antes de completar o ritual |
| Idle patrulha | Morcego | Sim | Movimento lateral de patrulha |
| Alerta | Morcego | Não | Indicativo visual antes do ataque — **implementado** |
| Ataque | Morcego | Não | Avanço em linha reta |
| Vibração | Estalagmite | Sim | Tremor crescente antes de cair |
| Queda | Estalagmite | Não | Queda vertical |
| Enxame (representação visual) | Enxame | Sim | Representa a "parede" da sequência de fuga — *pendente* |
| Flutuação | Lírio (item) | Sim | Balanço suave com brilho pulsante |

> 📌 O estado de Wall Slide reaproveita a animação `climb_idle`, por decisão de design — não recebe arte dedicada.

---

## 16. Arquitetura de Software

O projeto é estruturado em Godot 4 com GDScript, seguindo separação de responsabilidades por scripts e Autoloads para sistemas globais.

| Sistema | Tipo | Responsabilidades |
|---|---|---|
| GameManager | Autoload | Estado global, transições de fase, progresso do jogador, contagem de flores coletadas, checkpoints ativados |
| PlayerController | Script (FSM) | Input, física e animações de Eugene. Implementado como **Máquina de Estados Finitos (FSM)**: Idle, Run, Jump Up, Jump Fall, Dash, Climb, Wall Slide |
| Sistema de Trechos | Scripts (Orquestrador + Trigger) | Divide cada fase em sub-segmentos (trechos), instanciados e destruídos dinamicamente conforme o jogador avança/retrocede |
| CameraController | Script | Câmera 2D desacoplada do player, com limites e offset configuráveis por trecho |
| EnemyBase | Script (base) | Classe base para inimigos. Morcego herda desta classe |
| Sistema de Enxame | Script | Controla a sequência de fuga forçada (Fases 3 e 5), avançando continuamente e detectando contato com o jogador |
| Sistema de Checkpoint | Script (por instância) | Detecção de proximidade, interação, ativação de sonho na primeira vez, bloqueio/desbloqueio de controle |
| DreamOverlay | Autoload | Sequência visual e textual do sonho no checkpoint (fade de tela, texto com efeito de digitação) |
| DialogManager | Autoload | Sistema de diálogo genérico com efeito de digitação, reutilizado em placas informativas e em eventos narrativos pontuais |
| Sistema de Hazards | Script (genérico, via grupos) | Detecção padronizada de dano por contato, reutilizável em qualquer objeto do cenário |
| FlowerSystem | Script + GameManager | Coleta de lírios (um por fase), contagem centralizada, exibição no HUD |
| EndingManager | *(pendente)* | Verificação do buquê completo ao atingir o cume e disparo do final correto |
| TransitionEffect | Autoload | Efeito visual de transição (íris via shader), usado em respawn, troca de trecho, troca de fase e abertura do jogo |
| UIManager | Scripts distintos (MainMenu, PauseMenu, OptionsMenu, HUD) | HUD, menus, opções (incluindo remapeamento de controles), pausa |
| AudioManager | *(pendente)* | Reprodução e mistura de músicas e efeitos sonoros |

### Padrões de Projeto Aplicados

- **FSM** — `PlayerController` e inimigos (Morcego): garante que apenas um estado de movimentação esteja ativo por vez e que as transições sejam controladas e previsíveis.
- **Observer (Signals do Godot)** — usado extensivamente: `DialogManager`/`DreamOverlay` emitem sinais de conclusão que outros sistemas aguardam; checkpoints e flores comunicam eventos ao `GameManager` e ao HUD sem acoplamento direto.
- **Singleton (Autoload)** — `GameManager`, `DialogManager`, `DreamOverlay`, `TransitionEffect`, `HUD`, `PauseMenu` e `OptionsMenu` são acessíveis globalmente sem dependência de cena.
- **Reutilização via grupos** — o sistema de Hazards utiliza grupos do Godot (`"hazard"`) para permitir que qualquer objeto do cenário cause dano de forma padronizada, sem precisar herdar de uma classe específica.

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
| Pulo simples | 90% executam sem instrução explícita até o final da Fase 1 |
| Pulo duplo | 80% percebem e utilizam o pulo duplo sem dica até o final da Fase 1 |
| Dash | 80% conseguem executar o dash com intenção clara (não por acaso) até o final da Fase 1 |
| Wall jump | 70% conseguem wall jump consecutivo sem instrução até o final da Fase 1 |
| Escalada + resistência | 80% compreendem o limite de resistência pelo feedback visual (tremor) sem barra de HUD, até o final da Fase 1 |
| Sistema de checkpoints | 100% entendem que morrem e voltam ao ponto de respawn sem confusão |
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

| Milestone | Período | Descrição |
|---|---|---|
| Pesquisa e GDD | Março – Maio/2026 | Documentação, referências e reestruturações de design |
| Prototipagem inicial | Maio – Julho/2026 | Player Controller básico, sistema de câmera desacoplada, sistema de trechos, primeiros protótipos de diálogo e checkpoint |
| Sistemas centrais e inimigos | Agosto/2026 | Refinamento físico de pulo e dash (fórmulas matemáticas de altura/distância/tempo), morcego solo completo, primeiras iterações do enxame, base do sistema de hazards |
| Menus, Save e Level 1 | Setembro – 1ª quinzena de Outubro/2026 | Menu Principal, Pausa e Opções (áudio, vídeo, remapeamento teclado/controle), sistema de flores, checkpoint completo, Level 1 (Tutorial) funcional |
| Levels 2 e 3 | 1ª – 2ª quinzena de Outubro/2026 | Level 2 completo (morcego, flores, checkpoints, hazards); Level 3 com a sequência de fuga do enxame testada |
| Finalização das fases restantes e polimento | Outubro – meados de Novembro/2026 | Levels 4 e 5 (estalagmite, sistema de dois finais), arte e decoração final, save/load, ajustes de dificuldade, playtests, build final |

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
| Julho/2026 | Sistema de trechos (sub-segmentação de fases com câmera desacoplada) | Necessário para controlar a câmera de forma estável em fases grandes, evitando problemas técnicos de zonas de câmera fixas |
| Agosto/2026 | Pulo e dash recalculados matematicamente (altura/distância/tempo) | Maior controle e previsibilidade sobre o feel do movimento, facilitando ajustes futuros |
| Agosto/2026 | Dash reformulado como omnidirecional, com curva de aceleração/desaceleração e preservação de momentum | Dar mais vocabulário de movimento ao jogador, aproximando do feel de referências como Celeste |
| Agosto/2026 | Wall jump sem leitura de direção diagonal (impulso sempre fixo) | Mantém o desafio focado no timing da execução, não na precisão de ângulo |
| Agosto/2026 | Escalada com botão dedicado, não automática por proximidade | Evita agarrar em paredes sem intenção do jogador, especialmente com o dash omnidirecional |
| Agosto/2026 | Separação entre "pontos de respawn" (silenciosos, por trecho) e "checkpoints" (narrativos, com sonho) | Reduz a punição por erro, mantendo o ritmo ágil, sem abrir mão da estrutura narrativa dos checkpoints |
| Agosto/2026 | Enxame de morcegos reinterpretado como sequência de fuga forçada, em vez de IA de perseguição em grupo | IA de perseguição em grupo gerava comportamento imprevisível e difícil de calibrar como desafio justo |
| Agosto/2026 | Estalagmite causa dano em qualquer contato, mesmo presa no teto | Reforça o cuidado necessário ao se aproximar do inimigo |
| Agosto/2026 | Plataformas ambientais definidas como flutuantes, sem cordas ou suportes visíveis | Simplifica o escopo de arte e comportamento |
| Agosto/2026 | 1 flor por fase (5 no total), sem Álbum de Memórias no escopo atual | Álbum de Memórias representava trabalho de UI desproporcional ao prazo disponível |
| Setembro/2026 | Reversão da decisão de "suporte apenas a teclado": adicionado suporte completo a controle | Necessidade prática visando a apresentação em demoday |
| Setembro/2026 | Substituição da tela de game over por efeito de transição visual (íris via shader) | Mantém o ritmo do jogo sem interromper com uma tela dedicada |
| Setembro/2026 | Fase 1 estruturada em 2 partes (não 3, como as demais fases) | Papel estritamente introdutório, sem necessidade de uma terceira parte de consolidação |

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

## 24. Parecer do Comitê de Avaliação

### Avaliador 1

**Professor: Paulo Rogerio Pires Manseira**

**Status:** ✅ Aprovado

![Parecer — Prof. Manseira](https://github.com/user-attachments/assets/9b5747bf-15cb-4d4f-ace9-a778a45a0085)

---

### Avaliador 2

**Professor: Claudinei Dias**

**Status:** ✅ Aprovado

![Parecer — Prof. Claudinei](https://github.com/user-attachments/assets/d877f616-5f07-4b48-8801-54c14ce72304)

---

### Avaliador 3

**Professor: Diego Sauter Possamai**

**Status:** ✅ Aprovado

![Parecer — Prof. Diego](https://github.com/user-attachments/assets/1091abc9-3340-42bc-9746-a9b490831d16)

---

*ONE LAST CLIMB — GDD v1.1 | Felipe da Silva Chawischi | felipe.chawischi@catolica.edu*