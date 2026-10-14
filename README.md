# BPMN Modeler, Viewer e Batch Simulation

Aplicação web baseada em [bpmn-js](https://github.com/bpmn-io/bpmn-js) para modelar, visualizar e simular diagramas BPMN. A aplicação é totalmente estática (sem backend) e é empacotada com webpack e servida por nginx via Docker.

## Funcionalidades

- **Modelador** (`/`): edição de diagramas BPMN com tema Bizagi, importação e exportação de arquivos `.bpmn`.
- **Viewer** (`/viewer.html`): visualização de diagramas com simulação de tokens (`bpmn-js-token-simulation`) e simulação em lote (batch-sim) com distribuições, grafo e heatmap.
- **Diagramas de exemplo**: `pizza-collaboration.bpmn` e `qr-code.bpmn`, com configurações de simulação em `diagrams/simulations/`.

## Executando com Docker Compose

Pré-requisito: Docker e Docker Compose instalados e em execução.

Para construir a imagem e subir os serviços (Aplicação BPMN + Camunda):

```bash
docker compose up -d --build
```

Acesse:

* **Modelador**: [http://localhost:3000/](http://localhost:3000/)
* **Viewer e batch-sim**: [http://localhost:3000/viewer.html](http://localhost:3000/viewer.html)
* **Camunda BPM Platform**: [http://localhost:8080/](http://localhost:8080/)

Para parar os serviços:

```bash
docker compose down
```

## Executando apenas com Docker (sem Compose)

```bash
docker build -t bpmn-app .
docker run --rm -p 3000:80 bpmn-app
```

## Desenvolvimento local (sem Docker)

Pré-requisito: Node.js 22 ou superior.

```bash
npm ci
npm run dev     # servidor de desenvolvimento em http://localhost:8080
npm run build   # gera os bundles em dist/
```

## Estrutura do projeto

```
├── Dockerfile              # build (Node) + runtime (nginx)
├── docker-compose.yaml     # orquestração da aplicação BPMN e do Camunda
├── webpack.config.js       # entradas: bundle (modelador) e viewer
├── diagrams/               # diagramas de exemplo
│   └── simulations/        # configurações de simulação (.sim.json)
└── src/
    ├── index.html, app.js  # modelador
    ├── viewer.html, viewer.js
    ├── batchsim/           # motor de simulação em lote
    └── themes/             # temas CSS (Bizagi)
```

## Como o Docker serve a aplicação

O `Dockerfile` usa duas etapas:

1. **Build**: `npm ci` e `webpack --mode production`, gerando `bundle.js` e `viewer.js`.
2. **Runtime**: nginx serve na raiz os arquivos HTML, `themes/`, `diagrams/` (incluindo `simulations/`) e os bundles, reproduzindo o layout do servidor de desenvolvimento.
