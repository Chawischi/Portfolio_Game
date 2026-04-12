# 📋 Game Design Document (GDD)
## [Nome do Jogo a Definir]

| | |
|---|---|
| **Aluno** | Felipe da Silva Chawischi |
| **E-mail** | felipe.chawischi@catolica.edu |
| **Status** | Pesquisa / Prototipagem |
| **Versão** | v0.2 |
| **Última atualização** | 09/04/2026 |

---

## 🎯 1. Visão Geral

### 🧠 Elevator Pitch

Um jogo de plataforma 2D narrativo onde o jogador assume o papel de um idoso determinado a escalar uma montanha para cumprir a última promessa feita à sua esposa falecida. Ao longo da jornada, desafios de movimentação se entrelaçam com memórias do casal, reveladas por meio de flashbacks desbloqueados durante a exploração. A experiência combina mecânicas precisas e progressivas com uma narrativa emocional profunda.

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

## 📚 3. Pesquisa e Referências

### Jogos de Referência

**Celeste (2018) — Maddymakesgames**
Plataforma 2D com mecânicas precisas de dash e pulo. O jogo equilibra dificuldade elevada com uma narrativa emocional sobre saúde mental.
- Inspira: mecânicas de movimentação progressivas, feedback visual e sonoro de qualidade.

- A preencher ainda...

### Análise das Referências

- **Celeste** demonstra que mecânicas desafiadoras podem coexistir com narrativa emocional;
- A preencher...
---

## 💡 4. Hipóteses de Design

| Hipótese | Como será testada |
|----------|------------------|
| Jogadores se conectam emocionalmente com personagens idosos | Playtest com público diverso, coleta de feedback qualitativo |
| Flashbacks desbloqueados por exploração incentivam curiosidade | Observação de comportamento em playtest: jogadores exploram ou ignoram? |
| Mecânicas progressivas (planar, dash) enriquecem sem frustrar | Protótipo isolado de cada mecânica com medidor de tentativas |
| Ritmo contemplativo sustenta o engajamento até o fim | Medição de abandono em diferentes fases do jogo |

### Pilares do Jogo

1. **Emoções acima de tudo** — cada mecânica e decisão serve à narrativa emocional
2. **Progressão orgânica** — o personagem cresce junto com o jogador
3. **Contemplação e descoberta** — o ambiente recompensa quem explora
4. **Acessibilidade emocional** — qualquer pessoa deve conseguir sentir a história

---

## 🕹️ 5. Gameplay

### Core Loop

```
Explorar a fase → superar obstáculos de plataforma → encontrar objetos/locais de memória
→ desbloquear flashback narrativo → avançar para a próxima seção da montanha → repetir
```

### Loops Secundários

- Coletar fragmentos de memória pelas fases 
- Dominar novas habilidades de movimentação desbloqueadas ao longo da progressão

### Mecânicas Principais

| Mecânica | Descrição |
|----------|-----------|
| Pulo simples/duplo | O personagem pode pular e, no ar, realizar um segundo pulo para alcançar plataformas mais altas |
| Wall jump / escalada | Ao encostar em paredes, o jogador pode escalar ou saltar para o lado oposto |
| Dash | Movimento rápido horizontal para superar buracos ou evitar perigo |
| Planar | Ao cair de alturas, o personagem pode desacelerar a queda planeando brevemente |
| Corrida | Pressão prolongada do direcional aumenta velocidade de deslocamento |

### Câmera

Câmera lateral 2D com scroll automático suave seguindo o personagem. Pequenos offsets verticais antecipam plataformas acima. Em momentos de flashback, a câmera faz zoom suave e muda para paleta dessaturada.

### Sistemas

**Vitória**
O jogador chega ao topo da montanha e conclui o ritual de homenagem à esposa, desencadeando a cena final narrativa.

**Derrota**
Contato com inimigos (criaturas simples que dão dano ao toque), quedas em abismos ou pequenos desastres. Ao zerar, o personagem é reposicionado no último checkpoint.

**Progressão**
A cada fase concluída, uma nova habilidade de movimentação é desbloqueada. Flashbacks coletados ficam registrados num álbum de memórias acessível no menu de pausa.

---

## 📦 6. Escopo do Projeto

### O jogo inclui

- 4 a 6 fases distintas representando trechos da montanha
- 7 mecânicas de movimentação (pulo, pulo duplo, wall jump, escalada, dash, planar, corrida)
- Sistema de flashbacks narrativos por cenas estáticas (arte + texto)
- Tipos de inimigo: a preencher...
- Álbum de memórias para fragmentos coletados
- Menu principal, pausa e tela de game over
- Trilha sonora e efeitos sonoros
- Sistema de save em nuvem ou local || Em análise...

### O jogo não inclui

- Multiplayer
- Sistema de crafting ou inventário complexo
- Geração procedural de fases
- Localização para outros idiomas

---

## 🔬 7. Prototipagem

| Protótipo | Objetivo | Resultado |
|-----------|----------|-----------|
| Movimentação básica | Validar pulo e movimentação lateral no Godot | A preencher após execução |
| Wall jump | Testar sensibilidade e feel do salto de parede | A preencher |
| Sistema de flashback | Validar gatilho por coleta de item e exibição da cena estática | A preencher |
| Inimigo simples | Testar lógica de dano por contato e respawn no checkpoint | A preencher |
| Desastres na montanha | Testar danos e áreas do desastre | A preencher |

---

## 🖥️ 8. Interface (UI/UX)

### HUD

- Barra de resistência no canto superior esquerdo para quando estiver escalando
- Indicador discreto de fragmentos de memória coletados
- Nenhum elemento de HUD durante cenas de flashback (imersão total)

### Menus

- **Menu principal:** Jogar, Continuar, Opções, Sair
- **Menu de pausa:** Retomar, Álbum de Memórias, Opções, Menu Principal
- **Game over:** mensagem curta + botões Tentar Novamente / Menu Principal
- **Configurações:** volume música, volume efeitos, controles

### Flow de Menus

```
Menu Principal → Jogar → Fase ativa ←→ [Pausa] → Retomar ou Menu Principal
                                   → [Game Over] → Tentar novamente ou Menu Principal
```

### Controles

| Ação | Teclado | Controle (gamepad) |
|------|---------|-------------------|
| Mover | A / D ou setas | Analógico esquerdo / D-pad |
| Correr | Segurar Shift | Segurar X / Square |
| Pular / Pulo duplo | Espaço / W / seta cima | A / Cross |
| Dash | E ou Shift + direcional | B / Circle |
| Planar | Segurar pulo no ar | Segurar A / Cross |
| Wall jump | Pulo ao encostar na parede | A / Cross na parede |
| Pausar | Esc | Start / Options |

---

## 🎨 9. Direção Visual

### Direção de Arte

Pixel art de resolução média (personagens ~32×32 px, tilesets 16×16 px). Paleta principal:  a preencher... | Exemplo -> fria e neblinosa para o mundo presente (tons de azul, cinza, branco de neve) |. Durante flashbacks, paleta flashback: a preencher... |Exemplo ->  muda para tons quentes (âmbar, laranja suave, verde claro), contrastando visualmente os dois tempos narrativos. |

### Referências Visuais

- **Celeste** — pixel art expressivo, fundo de montanha com paralaxe
- A preencher...

> 📌 *Adicionar mood board e imagens de referência aqui*

---

## 🔊 10. Áudio

| Tipo | Onde usar | Loop? | Descrição |
|------|-----------|-------|-----------|
| Música ambiente (presente) | Fases jogadas | Sim | Piano e cordas suaves, melancolia serena |
| Música de flashback | Cenas de memória | Não | Tema nostálgico, mais quente e aconchegante |
| Trilha de tensão | Proximidade de inimigos | Sim | Sutileza, apenas elevação de tensão |
| SFX pulo | A cada pulo | Não | Som leve, sem peso excessivo |
| SFX dash | Ao usar o dash | Não | Whoosh curto e preciso |
| SFX coleta de memória | Ao pegar fragmento | Não | Nota musical suave e positiva |
| SFX dano | Ao sofrer dano | Não | Impacto leve, sem ser brutal |
| SFX checkpoint | Ao ativar checkpoint | Não | Som reconfortante, sensação de segurança |

---

## 🏃 11. Animação

| Animação | Personagem/Objeto | Loop? | Descrição |
|----------|-------------------|-------|-----------|
| Idle | Protagonista | Sim | Respiração suave, leve balanço |
| Caminhar | Protagonista | Sim | Passo cadenciado, posição curvada de idoso |
| Correr | Protagonista | Sim | Versão mais rápida do caminhar |
| Pulo | Protagonista | Não | Subida e descida distintas |
| Queda / Planeio | Protagonista | Sim | Braços abertos, corpo inclinado |
| Dash | Protagonista | Não | Quadros rápidos com trilha de partículas |
| Wall slide | Protagonista | Sim | Corpo raspando a parede |
| Dano | Protagonista | Não | Flash e recuo rápido |
| Idle | Inimigo | Sim | Movimento patrulha simples |
| Movimento | Inimigo | Sim | Deslocamento lateral no chão ou no ar |
| Fragmento de memória | Item | Sim | Flutuação suave com brilho pulsante |

---

## 🏗️ 12. Arquitetura de Software

O projeto será estruturado em Godot 4 com GDScript, seguindo separação de responsabilidades por scripts e uso de Autoloads para sistemas globais.

- `GameManager` *(Autoload)* — controla estado global, transições de cena e progresso do jogador
- `PlayerController` — input, física e animações do protagonista
- `EnemyBase` — classe base para comportamento de inimigos
- `MemorySystem` — gerencia coleta e exibição dos flashbacks
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

## 🧪 13. Testes e Playtests

### Playtests

| Data | Participantes | Principais problemas |
|------|---------------|----------------------|
| A preencher | A preencher | A preencher após realização dos playtests |

### Melhorias Implementadas

> A preencher após os ciclos de playtest.

---

## 📅 14. Cronograma

-** Sujeito a mudanças, é só uma base

| Milestone | Período previsto | Descrição |
|-----------|-----------------|-----------|
| Pesquisa e GDD | Março – Abril/2026 | Documentação, referências, conceito |
| Protótipo de movimentação | Maio/2026 | Mecânicas básicas jogáveis |
| Fase 1 jogável | Junho/2026 | Arte, level design e flashback integrados |
| Fases 2 e 3 | Julho/2026 | Expansão do conteúdo |
| Fases 4–6 + áudio | Agosto/2026 | Conclusão do conteúdo principal |
| Polimento e playtests | Setembro/2026 | Ajustes de dificuldade, bugs, UI |
| Build final + entrega | Outubro/2026 | Versão final para avaliação |

---

## ⚠️ 15. Riscos do Projeto

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| Escopo de arte muito grande | Atraso na produção | Limitar quantidade de assets; reutilizar sprites com variações |
| Mecânicas de movimentação complexas | Tempo excessivo de implementação | Implementar e validar uma mecânica por vez |
| Narrativa emocional não ressoar | Jogo perder identidade | Playtest cedo com foco em feedback emocional |
| Performance no WebGL | Experiência ruim no navegador | Testar build web desde as fases iniciais |
| Falta de tempo para polimento | Entrega com bugs | Buffer de 2 semanas reservado antes da entrega |

---

## 🚧 16. Limitações Conhecidas

- Multiplayer não será implementado
- Sistema de save em nuvem fora do escopo | Em análise
- Somente 1 tipo de inimigo (escopo controlado) | Em análise
- Localização apenas em português
- Arte criada pelo aluno: qualidade sujeita a evolução durante o projeto

---

## 📝 17. Decisões Importantes

-** Sujeito a mudanças, é só uma base

| Data | Decisão | Motivo |
|------|---------|--------|
| Abril/2026 | Flashbacks como cenas estáticas (arte + texto) | Mais viável para 1 pessoa; estilo reforça a nostalgia |
| Abril/2026 | Pixel art como estilo visual | Domínio da ferramenta (Aseprite); coerente com as referências |
| Abril/2026 | Godot 4 como engine | Open source, leve, excelente exportação WebGL, GDScript acessível |
| Abril/2026 | 4–6 fases como escopo máximo | Evitar escopo irrealista para TCC solo |

---

## 🙏 18. Créditos

| Recurso | Fonte | Licença |
|---------|-------|---------|
| Sprites do protagonista | Criados pelo aluno (Aseprite/Piskel) | — |
| Tilesets | A definir (OpenGameArt ou criado) | CC0 / autoral |
| Música | A definir (compositor ou asset livre) | CC-BY ou CC0 |
| Efeitos sonoros | A definir (freesound.org ou Audacity) | CC0 |

---

## 💭 19. Reflexão Final

> ⏳ *Esta seção deve ser preenchida ao final do projeto, após a entrega da versão final.*

**Principais desafios:** a preencher.

**Aprendizados técnicos:** a preencher.

**O que faria diferente:** a preencher.