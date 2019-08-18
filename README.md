# Plus 9k

## What it does

This action automatcially replies to `+1` comments to let the user know that the most 
helpful way is to either react with an emoji to an existing post or to provide more context.


## Usage

See [action.yml](action.yml) for all details

Full example:

```yaml
on: [issue_comment]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Run plus-9k
      uses: scepticulous/action-plus-9k@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        MESSAGE: "Please do not use +1 comments :slightly_frowning_face:"
```

## Input

* The `GITHUB_TOKEN`-env-var is required
* `MESSAGE`-input is optional, the default is provided [here](https://github.com/scepticulous/action-plus-9k/blob/master/lib/plus9k.rb#L14-L20).

## License

The scripts and documentation in this project are released under the [GPLv3](LICENSE)
