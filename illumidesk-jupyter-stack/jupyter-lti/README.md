# illumidesk_canvas

IllumiDesk canvas assignment submission button

## Prerequisites

* [Miniconda](https://conda.io/projects/continuumio-conda/en/latest/glossary.html#miniconda-glossary)

## Installation

```bash
jupyter labextension install jupyter-lti
```

## Development

Create and activate a `conda` virtual environment:

```bash
conda create -n jupyter-lti -c conda-forge --override-channels nodejs jupyterlab git
conda activate jupyter-lti
```

Use the `jlpm` yarn wrapper to install dependencies. Use `npm` or `yarn` if you prefer:

```bash
jlpm install
jupyter labextension install . --no-build
```

To run in watch (hot reload) mode, open a second terminal and run:

```bash
conda activate jupyter-lti
jupyter lab --watch
```

Updates may require a Shift + Enter to refresh your browser.

## Build

To rebuild the package:

```bash
npm run build
jupyter lab build
```

