<div align="center">
  <h1>Generic Semantic Version</h1>
  
  ![](https://github.com/jpradoar/ga-semanticversion/actions/workflows/main.yaml/badge.svg)
  ![](https://shields.io/badge/category-GitHub_Actions-orange?style=plastic&logo=github) 
  ![](https://img.shields.io/badge/license-MIT-brightgreen?style=plastic) 
  ![](https://shields.io/badge/maintainer-@jpradoar-blueviolet?style=plastic) 
</div>

<br>

This GitHub Action can be used to generate a semantic version. Usefull to create automatic tag/release or any other version. 
It's based on the semantic versioning standard X.Y.Z  
Ref: [https://semver.org/](https://semver.org/)
<br>
<div align="center"><img src="icon.png" /></div>
<br>


- Semantic version will be created from particular text in the commit. (major:  minor:, patch:  and more).
- This action enable you to use your own way to obtain a tag or version.
- You can use local files and parse it, or even parse a dockerhub remote tag.

<br>

```
git commit -m "patch:  bla bla bla"
                |      |
                |      |__ Subject
                |_________ Trigger
```

<br>

```mermaid
graph LR
    A(git push) --> B>GitHub Action]
    B --> C[Get old version ]
    C --> D[1.0.0]
    B --> | git commit -m text: ...| E{Parse Trigger}
    E --> |patch: ...| F((1.0.1))
    E --> |minor: ...| G((1.1.0))
    E --> |major: ...| H((2.0.0))
    E --> |test: ... | I((1.0.0-wbp9lays))
    E --> |alpine ...| J((1.0.0-alpine))

```

<br>

### Use example:

```yaml
      - uses: jpradoar/ga-semanticversion@v1.0.0
        with:
          COMMIT_MSG:  ${{ github.event.head_commit.message }}
          VERSION: ${{ steps.last_version_local_file.outputs.LAST_VERSION }}
```

<br>

### Required inputs in the action:
- <b>VERSION</b>: This input wait for a version number. You can use your own comand here. 
- <b>COMMIT_MSG</b>: This input get the commit text and use it to generate new version.

<br>

<div align="center">
  
### Description

|messaje              | description                                                                  |
|---                  |---                                                                           |
| patch:              | this is a patch or smal fix"                                                 | 
| minor:              | this is a minor implementation"                                              | 
| major:              | this is when you make incompatible API changes"                              | 
| test:               | this is only for make some test or a different version, add a random string" | 
| FooBar bla bla bla  | without ":"  ...this add a the first word in your commit message"            | 


<br>

### Examples
|Command                              | Old version | Patron                | New Version (result)  | 
|---                                  |---          |---                    | ---                   |
| commit -m "patch: text here"        | 1.0.0       | X.Y.[+1]              | 1.0.1                 | 
| commit -m "minor: text here"        | 1.0.0       | X.[+1].Z              | 1.1.0                 | 
| commit -m "major: text here"        | 1.0.0       | [+1].Y.Z              | 2.0.0                 | 
| commit -m "test: text here"         | 1.0.0       | X.Y.Z-[string]        | 1.0.0-wbp9lays        | 
| commit -m "alpine bla bla bla bla"  | 1.0.0       | X.Y.Z-[first-string]  | 1.0.0-alpine          | 
  
<i>(Example using version 1.0.0 as last old version) </i>
  
<br><br>
</div>  

### Example-Action (with local json file)
```yaml
name: Semantic-Version
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
jobs:
  Semantic-Version:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del repositorio
        uses: actions/checkout@v3        
      
      - name: Get las version of local file
        id: last_version_local_file
        run: |
          LastVersion=$(cat version-example.json |jq -r .version)
          echo "LAST_VERSION=$LastVersion " >> "$GITHUB_OUTPUT"
      
      - name: Generate new version with local file
        uses: jpradoar/ga-semanticversion@v1.0.0
        with:
          COMMIT_MSG:  ${{ github.event.head_commit.message }}
          VERSION: ${{ steps.last_version_local_file.outputs.LAST_VERSION }}
```

<br>

### Example-Action (with dockerhub)
```yaml
name: Semantic-Version
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  REPO_USER: 'jpradoar'
  REPO_APP: 'mqtt-consumer'

jobs:
  Semantic-Version:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del repositorio
        uses: actions/checkout@v3        

      - name: Show last version of docker-hub image
        id: last_version_remote_file
        run: |
          LastVersion=$(curl -s "https://hub.docker.com/v2/repositories/${{ env.REPO_USER }}/${{ env.REPO_APP }}/tags/?page_size=1" | jq -r '.results[].name'|sort -M|grep -v latest)
          echo "LAST_VERSION=$LastVersion " >> "$GITHUB_OUTPUT"

      - name: Generate new version with semantic version
        id: nversion
        uses: jpradoar/ga-semanticversion@v1.0.0
        with:
          COMMIT_MSG:  ${{ github.event.head_commit.message }}
          VERSION: ${{ steps.last_version_remote_file.outputs.LAST_VERSION }}

      - name: Show new version
        run: echo "New version ${{ steps.nversion.outputs.NEW_VERSION }}" 
```

<br>

### License 
The scripts and documentation in this project are released under the [MIT License](./LICENSE).

<br>

### Contributing and Support
All kinds of contributions are welcome ❤️ Please feel free to [create GitHub issues,PR](https://github.com/jpradoar/ga-semanticversion) for any feature requests, bugs, or documentation problems.
