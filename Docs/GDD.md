# 📋 Game Design Document
## One Last Climb

| | |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Pesquisa / Prototipagem |
| **Versão** | v0.5 |
| **Última atualização** | 12/04/2026 |

---

## 🎯 1. Visão Geral

### 🧠 Elevator Pitch

One Last Climb é um jogo de plataforma 2D com movimentação ágil e progressiva, onde o jogador controla Eugene, um velhinho teimoso e determinado que decide escalar uma montanha inteira para cumprir a última promessa que fez à sua esposa. O jogo é divertido primeiro: saltar, correr, dar dash e escalar paredes com precisão é o coração da experiência. A narrativa emocional entra pelas beiradas — nas flores que Eugene coleta pelo caminho, nos flashbacks que elas disparam e nas memórias que lhe dão literalmente novas forças para continuar subindo. O jogador começa achando que está jogando uma aventura leve de um velhinho cabeçudo. Só lá na frente percebe que estava sendo partido aos poucos.

### 🎮 Gênero

- **Gênero Principal:** Plataforma 2D
- **Gêneros Secundários:** Aventura, Narrativo

### 👥 Público-Alvo

Jogadores casuais e intermediários, principalmente entre adolescentes e adultos (16–35 anos), que apreciam experiências emocionais combinadas com desafios leves a moderados. Também busca atrair jogadores que valorizam narrativa e conexão com personagens.

### 💻 Plataformas

- PC (Windows)
- Web via itch.io (build WebGL)

---

## 🔗 2. Acesso ao Projeto

| Item | Link |
|------|------|
| Build jogável | itch.io — a preencher |
| Repositório | GitHub — a preencher |
| Vídeo gameplay (opcional) | YouTube — a preencher |
| Instruções de execução | Godot 4.x \| Windows 10+ \| Teclado ou controle |

---

## 👤 3. Personagens

### Eugene — O Protagonista

Idoso determinado a cumprir a última promessa feita à esposa. Sua jornada é tanto física (escalar a montanha) quanto emocional (superar a perda e honrar a memória de Liliana). O nome foi escolhido por remeter a uma geração mais velha, carregando peso e personalidade.

No gameplay, isso se reflete na sua movimentação: Eugene começa lento e limitado, e suas habilidades crescem conforme ele revive memórias de Liliana — como se o amor e as lembranças fossem literalmente lhe dando forças para continuar.

### Liliana — A Esposa

Presente no jogo apenas através das memórias, das flores e das frases que deixou na vida de Eugene. Nunca aparece diretamente no gameplay — sua presença é construída pelos flashbacks.

- Nome de origem latina (*lilium*) — significa lírio, a flor central do jogo
- Raízes gregas (*Elisábet*) com significado de "meu Deus é um juramento" — ligação simbólica com a promessa do jogo
- Apaixonada por história e literatura, o que justifica as citações latinas e nórdicas nos flashbacks

---

## 📚 4. Pesquisa e Referências

### Jogos de Referência

**Celeste (2018) — Maddymakesgames**
Plataforma 2D com mecânicas precisas de dash e pulo. O jogo equilibra dificuldade elevada com uma narrativa emocional sobre saúde mental.
- Inspira: mecânicas de movimentação progressivas, feedback visual e sonoro de qualidade, coexistência entre desafio e narrativa emocional.

> 📌 *Adicionar screenshots e análise de outras referências aqui conforme a pesquisa avança.*

### Análise das Referências

- **Celeste** demonstra que mecânicas desafiadoras podem coexistir com narrativa emocional profunda.

> 📌 *Expandir com novas referências ao longo do desenvolvimento.*

---

## 💡 5. Hipóteses de Design

| Hipótese | Como será testada |
|----------|------------------|
| Jogadores se conectam emocionalmente com personagens idosos | Playtest com público diverso, coleta de feedback qualitativo |
| Flashbacks desbloqueados por coleta de flores incentivam exploração | Observação em playtest: jogadores exploram ou ignoram as flores? |
| Mecânicas progressivas enriquecem sem frustrar | Protótipo isolado de cada mecânica com medidor de tentativas |
| O tom leve e divertido potencializa o impacto emocional dos momentos narrativos | Medir reação emocional em playtest: o contraste leve/pesado funciona? |
| A associação frase → habilidade é percebida pelo jogador | Perguntar após o playtest se o jogador percebeu a ligação temática |

### Pilares do Jogo

1. **Gameplay divertido primeiro** — o jogo precisa ser prazeroso de jogar antes de qualquer mensagem emocional. Movimento ágil, responsivo e satisfatório é a base de tudo.
2. **Leveza como veículo da emoção** — o jogo trata de assuntos sérios (luto, perda, promessa) através de uma superfície leve e bem-humorada. O impacto emocional é maior justamente porque o jogador foi pego de surpresa. Referência direta à "tática Disney": vender emoção pesada com embrulho colorido e musical.
3. **Progressão orgânica** — o personagem cresce junto com o jogador, e cada nova habilidade tem razão narrativa para existir.
4. **Contemplação e descoberta** — o ambiente recompensa quem explora, sem forçar o ritmo.

---

## 🕹️ 6. Gameplay

### Core Loop

O núcleo do jogo é o movimento: pular, correr, dar dash e explorar plataformas é o que o jogador faz a maior parte do tempo, e precisa ser divertido por si só. A narrativa entra como recompensa — cada lírio coletado interrompe brevemente a ação com um flashback e devolve o jogador ao movimento com uma nova habilidade desbloqueada.

```
Explorar a fase → superar obstáculos de plataforma → encontrar lírio
→ flashback desbloqueado → frase de Eugene exibida → nova habilidade desbloqueada
→ avançar para a próxima seção da montanha → repetir
```

### Loops Secundários

- Coletar todos os lírios da fase para completar o álbum de memórias
- Dominar e encadear novas habilidades de movimentação desbloqueadas progressivamente

### Mecânicas Principais

| Mecânica | Descrição |
|----------|-----------|
| Pulo simples | Disponível desde o início. Responsivo e preciso — base de toda a movimentação. |
| Corrida | Segurar o direcional aumenta a velocidade. Dá ritmo e fluidez ao deslocamento. |
| Dash | Impulso horizontal rápido para superar buracos ou escapar de inimigos. Satisfatório de usar. Desbloqueado na Fase 2. |
| Pulo duplo | Segundo pulo no ar para alcançar plataformas mais altas. Abre novas possibilidades de rota. Desbloqueado na Fase 3. |
| Wall jump | Saltar entre paredes em sequência rápida. Mecânica que exige timing e recompensa o domínio. Desbloqueado no final da Fase 3. |
| Planear | Segurar o pulo durante a queda desacelera Eugene. Controle extra sobre o movimento aéreo. Desbloqueado na Fase 4. |

> **Nota de design:** Eugene começa limitado porque é um idoso se lançando a uma tarefa impossível — e isso é engraçado e tocante ao mesmo tempo. Cada habilidade nova é uma memória de Liliana que lhe devolve um pedaço de energia. O jogador sente isso no controle, não só na narrativa.

### Câmera

Câmera lateral 2D com scroll automático suave seguindo o personagem. Pequenos offsets verticais antecipam plataformas acima. Em momentos de flashback, a câmera faz zoom suave e muda para paleta dessaturada/quente (ver Direção Visual).

### Sistemas

**Vitória**
Eugene chega ao topo da montanha, forma o buquê com todas as flores coletadas e realiza o ritual de homenagem a Liliana, desencadeando a cena final narrativa.

**Derrota**
Contato com inimigos, quedas em abismos ou exposição a eventos climáticos. Ao zerar, o personagem é reposicionado no último checkpoint com um som reconfortante.

**Progressão**
A cada fase concluída, um lírio é coletado e uma nova habilidade de movimentação é desbloqueada. Os flashbacks ficam registrados num álbum de memórias acessível no menu de pausa.

---

## 🌸 7. Sistema de Flores e Flashbacks

Esta é a mecânica que conecta gameplay e narrativa. O movimento é interrompido brevemente por uma memória — e retomado com mais força.

### Como funciona

1. Eugene encontra um lírio em algum ponto da fase
2. Ao coletar a flor, um flashback é disparado
3. O flashback exibe uma cena estática (arte + texto) mostrando uma memória do casal
4. Ao final do flashback, Eugene diz algo em voz alta — uma frase curta, no tom dele, lembrando das palavras de Liliana à sua maneira
5. Eugene desbloqueia uma nova habilidade de movimentação
6. A flor é adicionada ao buquê em formação (visível no álbum de memórias)

### Associação: Flor → Frase → Habilidade

> As frases não são citações acadêmicas — são Eugene lembrando, do jeito dele, de algo que Liliana dizia. Tom leve, afetivo, às vezes com um humor involuntário de velho teimoso.

| # | Fase | Frase (Eugene lembrando) | Origem da ideia | Habilidade |
|---|------|--------------------------|-----------------|-----------|
| 1 | Fase 2 | *"Ela sempre dizia: o amor empurra a gente pra frente. Acho que era latim. Amor... algo. Funcionava de qualquer jeito."* | Amor vincit omnia — Virgílio | **Dash** |
| 2 | Fase 3 | *"Enquanto eu respirar, eu tenho esperança. Foi ela que me ensinou isso. Ainda funciona."* | Dum spiro, spero — Cícero | **Pulo duplo** |
| 3 | Fase 3 | *"O destino sempre acha um jeito, ela dizia. Eu acho que o destino sou eu escalando essa montanha ridícula."* | Fata viam invenient — Virgílio | **Wall jump** |
| 4 | Fase 4 | *"Os velhos vikings diziam que a memória dos mortos nunca morre. Ela adorava isso. Eu entendo agora."* | Hávamál nórdico | **Planear** |
| 5 | Fase 5 | *"Às estrelas pelas dificuldades. Era o jeito favorito dela de dizer: vai lá, Eugene."* | Ad astra per aspera | **Corrida aprimorada** |

### Frases reservadas para momentos narrativos (sem habilidade)

- *"Tudo por você."* — Eugene ao iniciar a escalada (simples, direto, sem floreio)
- *"Aquele que o amor não toca caminha nas trevas. Ela falava isso quando eu reclamava demais. Tinha razão."* — momento narrativo interno

### Frases ditas por Eugene (momentos-chave)

- *"Reunidos em breve."* — ao chegar ao topo
- *"A última escalada prometida."* — ao iniciar a jornada
- *"Por você minha querida, qualquer coisa."* — durante a escalada

---

## 🗺️ 8. Estrutura das Fases

O jogo possui **5 fases**, representando trechos progressivos da escalada de Eugene.

| Fase | Ambiente | Tom narrativo | Novidade de gameplay | Inimigos presentes |
|------|----------|--------------|---------------------|--------------------|
| 1 | Base da montanha — floresta e trilha inicial | Introdução leve. Eugene começa reclamando da subida. | Pulo simples + corrida (habilidades iniciais) | Morcego |
| 2 | Entrada da caverna — ambiente meio morto, pedras e raízes | Transição. O caminho começa a pesar, mas Eugene ainda faz piada. | Dash desbloqueado (flor 1) | Estalagmite instável |
| 3 | Caverna profunda | O humor diminui. As memórias ficam mais pesadas. | Pulo duplo + Wall jump desbloqueados (flores 2 e 3) | Partículas de estalagmite, vento |
| 4 | Caverna densa e escura — ponto mais difícil do jogo | Momento mais sombrio. Eugene para de falar. Só continua. | Planear desbloqueado (flor 4) | Combinação dos anteriores |
| 5 | Caverna clareando → saída para o cume | Alívio. A luz volta. Eugene chora — mas chega. | Corrida aprimorada (flor 5). Sem novos inimigos. | Nenhum — apenas o caminho |

> **Nota de design:** A progressão escuridão → luz é uma metáfora intencional sobre o luto. O tom do Eugene acompanha: começa bem-humorado, vai silenciando conforme a emoção pesa, e termina em resolução. A fase 5 não apresenta inimigos deliberadamente — o caminho final deve ser de contemplação.

---

## ⚔️ 9. Inimigos e Obstáculos

### Inimigos

| Inimigo | Fase(s) | Comportamento | Dano |
|---------|---------|--------------|------|
| Morcego | 1, 2 | Patrulha lateral no ar; ao detectar o jogador, avança em linha reta | Dano por contato |
| Estalagmite instável | 2, 3 | Estática no teto; vibra ao jogador se aproximar, cai após alguns segundos | Dano ao cair sobre Eugene |
| Partículas de estalagmite | 3, 4 | Partículas liberadas por estalagmites fraturadas; ficam suspensas em área | Dano por contato com a nuvem de partículas |
| Vento | 3, 4 | Rajadas horizontais que empurram Eugene; não causam dano direto mas podem jogar no abismo | Dano indireto (queda) |

> **Nota de escopo:** A implementação de vento e partículas é condicional ao tempo disponível. O morcego e a estalagmite são os inimigos prioritários.

### Obstáculos Ambientais

- Abismos entre plataformas
- Plataformas móveis (a confirmar no protótipo)
- Trechos de parede para wall jump obrigatório
- Zonas de queda livre onde o planear é necessário

---

## 📦 10. Escopo do Projeto

### O jogo inclui

- 5 fases distintas representando trechos da montanha
- 6 mecânicas de movimentação progressivas (pulo, corrida, dash, pulo duplo, wall jump, planear)
- 5 flashbacks narrativos por cenas estáticas (arte + texto), um por fase
- 2 frases narrativas adicionais sem mecânica associada
- Tipos de inimigo: morcego, estalagmite instável, partículas, vento (os dois últimos condicionais ao tempo)
- Álbum de memórias para flores e flashbacks coletados
- Menu principal, pausa e tela de game over
- Trilha sonora e efeitos sonoros
- Sistema de save local

### O jogo não inclui

- Multiplayer
- Sistema de crafting ou inventário complexo
- Geração procedural de fases
- Localização para outros idiomas (somente português)
- Sistema de save em nuvem (fora do escopo)

---

## 🔬 11. Prototipagem

| Protótipo | Objetivo | Resultado |
|-----------|----------|-----------|
| Movimentação básica | Validar pulo e movimentação lateral no Godot | A preencher após execução |
| Dash | Testar sensibilidade e feel do dash | A preencher |
| Wall jump | Testar sensibilidade e feel do salto de parede | A preencher |
| Planear | Validar controle de queda e sensação de flutuar | A preencher |
| Sistema de flashback | Validar gatilho por coleta de flor e exibição da cena estática | A preencher |
| Inimigo morcego | Testar lógica de patrulha e dano por contato | A preencher |
| Estalagmite instável | Testar gatilho de queda e dano | A preencher |

---

## 🖥️ 12. Interface (UI/UX)

### HUD

- Barra de resistência discreta (canto superior esquerdo) — ativa apenas em trechos de escalada de parede
- Indicador discreto de flores coletadas na fase atual
- HUD completamente oculto durante cenas de flashback (imersão total)

### Menus

- **Menu principal:** Jogar, Continuar, Opções, Sair
- **Menu de pausa:** Retomar, Álbum de Memórias, Opções, Menu Principal
- **Game over:** mensagem curta + botões Tentar Novamente / Menu Principal
- **Configurações:** volume música, volume efeitos, controles

### Flow de Telas

```
Menu Principal → Jogar → Fase ativa ←→ [Pausa] → Retomar ou Menu Principal
                                    → [Flashback] → retorna à fase
                                    → [Game Over] → Tentar novamente ou Menu Principal
```

### Controles

| Ação | Teclado | Controle (gamepad) |
|------|---------|-------------------|
| Mover | A / D ou setas | Analógico esquerdo / D-pad |
| Correr | Segurar Shift | Segurar X / Square |
| Pular / Pulo duplo | Espaço / W / seta cima | A / Cross |
| Dash | E ou Shift + direcional | B / Circle |
| Planear | Segurar pulo no ar | Segurar A / Cross |
| Wall jump | Pulo ao encostar na parede | A / Cross na parede |
| Pausar | Esc | Start / Options |

---

## 🎨 13. Direção Visual

### Direção de Arte

Pixel art de resolução média (personagens ~32×32 px, tilesets 16×16 px).

**Paleta do mundo presente** (fases jogadas): tons frios e neblinosos — azul, cinza, branco de neve. Transmite a solidão e o peso da perda.

**Paleta dos flashbacks**: tons quentes — âmbar, laranja suave, verde claro. O contraste visual entre os dois tempos narrativos é intencional: o passado com Liliana era quente e vivo; o presente de Eugene é frio e solitário.

### Referências Visuais

- **Celeste** — pixel art expressivo, fundos de montanha com paralaxe, uso emocional de cor

> 📌 *Adicionar mood board, paletas concretas e exemplos de assets*

---

## 🔊 14. Áudio

| Tipo | Onde usar | Loop? | Descrição |
|------|-----------|-------|-----------|
| Música ambiente (presente) | Fases jogadas | Sim | Piano e cordas suaves, melancolia serena |
| Música de flashback | Cenas de memória | Não | Tema nostálgico, mais quente e aconchegante |
| Trilha de tensão | Proximidade de inimigos | Sim | Elevação sutil de tensão, sem ser agressiva |
| SFX pulo | A cada pulo | Não | Som leve, sem peso excessivo |
| SFX dash | Ao usar o dash | Não | Whoosh curto e preciso |
| SFX coleta de flor | Ao pegar o lírio | Não | Nota musical suave e positiva |
| SFX dano | Ao sofrer dano | Não | Impacto leve, sem ser brutal |
| SFX checkpoint | Ao ativar checkpoint | Não | Som reconfortante, sensação de segurança |

---

## 🏃 15. Animação

| Animação | Personagem/Objeto | Loop? | Descrição |
|----------|-------------------|-------|-----------|
| Idle | Eugene | Sim | Respiração suave, leve balanço |
| Caminhar | Eugene | Sim | Passo cadenciado, posição levemente curvada de idoso |
| Correr | Eugene | Sim | Versão mais rápida do caminhar |
| Pulo | Eugene | Não | Subida e descida com frames distintos |
| Queda / Planear | Eugene | Sim | Braços abertos, corpo inclinado |
| Dash | Eugene | Não | Frames rápidos com trilha de partículas |
| Wall slide | Eugene | Sim | Corpo raspando a parede |
| Dano | Eugene | Não | Flash e recuo rápido |
| Idle patrulha | Morcego | Sim | Movimento lateral de patrulha |
| Ataque | Morcego | Não | Avanço em linha reta ao detectar Eugene |
| Vibração | Estalagmite | Sim | Tremor crescente antes de cair |
| Queda | Estalagmite | Não | Queda vertical |
| Flutuação | Lírio (item) | Sim | Balanço suave com brilho pulsante |

---

## 🏗️ 16. Arquitetura de Software

O projeto será estruturado em Godot 4 com GDScript, seguindo separação de responsabilidades por scripts e uso de Autoloads para sistemas globais.

- `GameManager` *(Autoload)* — controla estado global, transições de cena e progresso do jogador
- `PlayerController` — input, física e animações de Eugene
- `EnemyBase` — classe base para comportamento de inimigos (morcego, estalagmite)
- `FlowerSystem` — gerencia coleta de flores, disparo de flashbacks e desbloqueio de habilidades
- `UIManager` — controla HUD, menus e transições de tela
- `AudioManager` *(Autoload)* — reproduz e mistura músicas e efeitos sonoros

### Tecnologias Utilizadas

| Categoria | Ferramenta |
|-----------|-----------|
| Engine | Godot 4.x |
| Linguagem | GDScript |
| Versionamento | Git + GitHub |
| Arte / Sprites | Aseprite (pixel art) |
| Áudio | Audacity / assets livres de royalties |
| Build Web | Exportação WebGL do Godot → itch.io |

---

## 🧪 17. Testes e Playtests

### Playtests

| Data | Participantes | Principais problemas |
|------|---------------|----------------------|
| A preencher | A preencher | A preencher após realização dos playtests |

### Melhorias Implementadas

> A preencher após os ciclos de playtest.

---

## 📅 18. Cronograma

*Sujeito a mudanças — base de planejamento.*

| Milestone | Período previsto | Descrição |
|-----------|-----------------|-----------|
| Pesquisa e GDD | Março – Abril/2026 | Documentação, referências, conceito |
| Protótipo de movimentação | Maio/2026 | Mecânicas básicas jogáveis (pulo, corrida, dash) |
| Fase 1 jogável | Junho/2026 | Arte, level design e primeiro flashback integrados |
| Fases 2 e 3 | Julho/2026 | Expansão do conteúdo, wall jump e pulo duplo |
| Fases 4 e 5 + áudio | Agosto/2026 | Conclusão do conteúdo principal, planear, cume |
| Polimento e playtests | Setembro/2026 | Ajustes de dificuldade, bugs, UI, álbum de memórias |
| Build final + entrega | Outubro/2026 | Versão final para avaliação |

---

## ⚠️ 19. Riscos do Projeto

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| Escopo de arte muito grande | Atraso na produção | Limitar quantidade de assets; reutilizar sprites com variações de cor e flip |
| Mecânicas de movimentação complexas | Tempo excessivo de implementação | Implementar e validar uma mecânica por vez, na ordem das fases |
| Narrativa emocional não ressoar | Jogo perde identidade | Playtest cedo com foco em feedback emocional |
| Performance no WebGL | Experiência ruim no navegador | Testar build web desde as fases iniciais |
| Falta de tempo para polimento | Entrega com bugs | Buffer de 2 semanas reservado antes da entrega |
| Inimigos mais complexos (vento, partículas) consumirem tempo demais | Escopo inflado | Tratar vento e partículas como bônus — implementar apenas se o escopo principal estiver completo |

---

## 🚧 20. Limitações Conhecidas

- Multiplayer não será implementado
- Sistema de save em nuvem fora do escopo (save local)
- Vento e partículas de estalagmite condicionais ao tempo disponível
- Localização apenas em português (frases latinas e nórdicas mantidas no idioma original, ditas por Eugene no tom dele)
- Arte criada pelo aluno: qualidade sujeita a evolução durante o projeto

---

## 📝 21. Decisões Importantes

*Sujeito a mudanças — registro de decisões de design.*

| Data | Decisão | Motivo |
|------|---------|--------|
| Abril/2026 | Flashbacks como cenas estáticas (arte + texto) | Mais viável para 1 pessoa; estilo reforça a nostalgia |
| Abril/2026 | Pixel art como estilo visual | Domínio da ferramenta (Aseprite); coerente com as referências |
| Abril/2026 | Godot 4 como engine | Open source, leve, excelente exportação WebGL, GDScript acessível |
| Abril/2026 | 5 fases como escopo | Equilíbrio entre conteúdo satisfatório e viabilidade para TCC solo |
| Abril/2026 | Cada flor = 1 frase + 1 habilidade | Une narrativa e mecânica de forma orgânica; a frase justifica a habilidade tematicamente |
| Abril/2026 | Fase 5 sem inimigos | Metáfora intencional: o caminho final é de contemplação, não de conflito |
| Abril/2026 | Frases ditas por Eugene no tom dele, não como citações formais | Torna a narrativa mais humana e acessível; evita o tom acadêmico e mantém o humor involuntário do personagem |
| Abril/2026 | Tom leve na superfície, emoção pesada por baixo (tática Disney) | O impacto emocional é maior quando o jogador é pego de surpresa. Tratar assuntos sérios com leveza é uma escolha narrativa intencional, não uma concessão. |

---

## 🙏 22. Créditos

| Recurso | Fonte | Licença |
|---------|-------|---------|
| Sprites do protagonista | Criados pelo aluno (Aseprite) | — |
| Tilesets | A definir (OpenGameArt ou criado) | CC0 / autoral |
| Música | A definir (compositor ou asset livre) | CC-BY ou CC0 |
| Efeitos sonoros | A definir (freesound.org ou Audacity) | CC0 |

---

## 💭 23. Reflexão Final

> ⏳ *Esta seção deve ser preenchida ao final do projeto, após a entrega da versão final.*

**Principais desafios:** a preencher.

**Aprendizados técnicos:** a preencher.

**O que faria diferente:** a preencher.
