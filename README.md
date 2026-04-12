# 📋 Game Design Document (GDD)
## One Last Climb

| | |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Pesquisa / Prototipagem |
| **Versão** | v0.4 |
| **Última atualização** | 12/04/2026 |

---

## 🎯 1. Visão Geral

### 🧠 Elevator Pitch

Um jogo de plataforma 2D narrativo onde o jogador assume o papel de Eugene, um idoso determinado a escalar uma montanha para cumprir a última promessa feita à sua esposa falecida. Ao longo da jornada, desafios de movimentação se entrelaçam com memórias do casal, reveladas por meio de flashbacks desbloqueados pela coleta de lírios espalhados pela montanha. Cada flor traz uma citação que Liliana — apaixonada por história e literatura — compartilhou com Eugene ao longo da vida, e cada memória concede uma nova habilidade ao jogador. Ao chegar ao topo, todas as flores formam um buquê: o cumprimento da promessa.

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
| Ritmo contemplativo sustenta o engajamento até o fim | Medição de abandono em diferentes fases do jogo |
| A associação frase → habilidade é percebida pelo jogador | Perguntar após o playtest se o jogador percebeu a ligação temática |

### Pilares do Jogo

1. **Emoções acima de tudo** — cada mecânica e decisão serve à narrativa emocional
2. **Progressão orgânica** — o personagem cresce junto com o jogador
3. **Contemplação e descoberta** — o ambiente recompensa quem explora
4. **Acessibilidade emocional** — qualquer pessoa deve conseguir sentir a história

---

## 🕹️ 6. Gameplay

### Core Loop

```
Explorar a fase → superar obstáculos de plataforma → encontrar lírio
→ flashback desbloqueado → frase de Liliana exibida → nova habilidade desbloqueada
→ avançar para a próxima seção da montanha → repetir
```

### Loops Secundários

- Coletar todos os fragmentos de memória da fase (lírios) para completar o álbum
- Dominar novas habilidades de movimentação desbloqueadas progressivamente

### Mecânicas Principais

| Mecânica | Descrição |
|----------|-----------|
| Pulo simples | Disponível desde o início. O personagem salta para alcançar plataformas. |
| Corrida | Pressionar o direcional por mais tempo aumenta a velocidade de deslocamento. |
| Dash | Movimento rápido horizontal para superar buracos ou evitar perigo. Desbloqueado na Fase 2. |
| Pulo duplo | No ar, o jogador pode realizar um segundo pulo para alcançar alturas maiores. Desbloqueado na Fase 3. |
| Wall jump | Ao encostar em paredes, o jogador pode saltar para o lado oposto. Desbloqueado no final da Fase 3. |
| Planear | Ao cair de alturas, o personagem desacelera a queda planeando brevemente. Desbloqueado na Fase 4. |

> **Nota de design:** Eugene começa com habilidades limitadas (pulo simples + corrida) porque isso reforça narrativamente que ele é um idoso se lançando a uma tarefa difícil. Cada habilidade nova é um presente de Liliana — uma memória que lhe dá força.

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

Esta é a mecânica central que conecta gameplay e narrativa.

### Como funciona

1. Eugene encontra um lírio em algum ponto da fase
2. Ao coletar a flor, um flashback é disparado
3. O flashback exibe uma cena estática (arte + texto) mostrando uma memória do casal
4. Ao final do flashback, uma frase histórica citada por Liliana aparece na tela
5. Eugene desbloqueia uma nova habilidade de movimentação
6. A flor é adicionada ao buquê em formação (visível no álbum de memórias)

### Associação: Flor → Frase → Habilidade

| # | Fase | Frase | Tradução | Origem | Habilidade |
|---|------|-------|----------|--------|-----------|
| 1 | Fase 2 | *"Amor vincit omnia"* | O amor conquista tudo | Virgílio — Éclogas (37 a.C.) | **Dash** — o amor impulsiona, avança |
| 2 | Fase 3 | *"Dum spiro, spero"* | Enquanto respiro, tenho esperança | Cícero (séc. I a.C.) | **Pulo duplo** — esperança é alcançar mais alto |
| 3 | Fase 3 | *"Fata viam invenient"* | O destino encontrará um caminho | Virgílio — Eneida (19 a.C.) | **Wall jump** — encontrar caminho nas paredes |
| 4 | Fase 4 | *"Cattle die... the memory of the dead"* | A memória dos mortos nunca morre | Hávamál — poema nórdico (séc. XIII) | **Planear** — a memória sustenta, não deixa cair |
| 5 | Fase 5 | *"Ad astra per aspera"* | Às estrelas através das dificuldades | Latim anônimo | **Corrida aprimorada** — o esforço final rumo ao topo |

### Frases reservadas para momentos narrativos (sem habilidade)

Estas frases aparecem nos flashbacks ou em momentos-chave da história, sem estar associadas a uma mecânica — o que reforça que nem toda memória precisa de recompensa mecânica:

- *"Omnia pro te"* — Tudo por você (Latim clássico)
- *"He whom love touches not walks in darkness"* — Aquele que o amor não toca, caminha nas trevas (Platão — O Banquete, 385 a.C.)

### Frases ditas por Eugene (momentos-chave da narrativa)

- *"Reunidos em breve"* — ao chegar ao topo
- *"A última escalada prometida"* — ao iniciar a jornada
- *"Por você minha querida, qualquer coisa."* — durante a escalada

---

## 🗺️ 8. Estrutura das Fases

O jogo possui **5 fases**, representando trechos progressivos da escalada de Eugene.

| Fase | Ambiente | Tom narrativo | Novidade de gameplay | Inimigos presentes |
|------|----------|--------------|---------------------|--------------------|
| 1 | Base da montanha — floresta e trilha inicial | Introdução. Leve melancolia. Eugene começa sua jornada. | Pulo simples + corrida (habilidades iniciais) | Morcego |
| 2 | Entrada da caverna — ambiente meio morto, pedras e raízes | Transição. O caminho começa a pesar. | Dash desbloqueado (flor 1) | Estalagmite instável |
| 3 | Caverna profunda | Escuridão e peso emocional. Clímax narrativo da primeira metade. | Pulo duplo + Wall jump desbloqueados (flores 2 e 3) | Partículas de estalagmite, vento |
| 4 | Caverna densa e escura — ponto mais difícil do jogo | Momento mais sombrio. Eugene enfrenta a escuridão total. | Planear desbloqueado (flor 4) | Combinação dos anteriores |
| 5 | Caverna clareando → saída para o cume | Alívio e resolução. A luz retorna. O topo revela a vista prometida. | Corrida aprimorada (flor 5). Sem novos inimigos. | Nenhum — apenas o caminho |

> **Nota de design:** A progressão escuridão → luz é uma metáfora intencional sobre o luto. Eugene entra nas profundezas (da montanha e da dor) e emerge para a luz (resolução e cumprimento da promessa). A fase 5 não apresenta inimigos deliberadamente — o caminho final deve ser de contemplação.

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
- A preencher com mood board, paletas concretas e exemplos de assets

> 📌 *Adicionar mood board e imagens de referência aqui*

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
- Localização apenas em português (frases latinas e nórdicas mantidas no idioma original)
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
| Abril/2026 | Cada flor = 1 frase + 1 habilidade | Une narrativa e mecânica de forma orgânica; a frase justifica a habilidade temáticamente |
| Abril/2026 | Fase 5 sem inimigos | Metáfora intencional: o caminho final é de contemplação, não de conflito |
| Abril/2026 | Frases latinas/nórdicas mantidas no idioma original | Reforçam a personalidade de Liliana e adicionam peso cultural ao texto |

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
