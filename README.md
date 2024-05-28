<h1>
  <p align="center">
    UNMAINTAINED: External repo/wiki sync action
  </p>
</h1>
<div align="center">
  This repository provides a GitHub action to push files/binaries 
  to <strong>external repositories</strong>.
  Per default, the action uses the wiki of the current repo, but you can specify other repos as well.

[![Release](https://badgen.net/github/release/kai-tub/external-repo-sync-action/)](https://github.com/kai-tub/external-repo-sync-action/releases)
[![GitHub license](https://badgen.net/github/license/kai-tub/external-repo-sync-action/)](https://github.com/kai-tub/external-repo-sync-action/blob/master/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg?color=blue)](CODE_OF_CONDUCT.md)
[![Auto Release](https://img.shields.io/badge/release-auto.svg?colorA=888888&colorB=9B065A&label=auto&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAACzElEQVR4AYXBW2iVBQAA4O+/nLlLO9NM7JSXasko2ASZMaKyhRKEDH2ohxHVWy6EiIiiLOgiZG9CtdgG0VNQoJEXRogVgZYylI1skiKVITPTTtnv3M7+v8UvnG3M+r7APLIRxStn69qzqeBBrMYyBDiL4SD0VeFmRwtrkrI5IjP0F7rjzrSjvbTqwubiLZffySrhRrSghBJa8EBYY0NyLJt8bDBOtzbEY72TldQ1kRm6otana8JK3/kzN/3V/NBPU6HsNnNlZAz/ukOalb0RBJKeQnykd7LiX5Fp/YXuQlfUuhXbg8Di5GL9jbXFq/tLa86PpxPhAPrwCYaiorS8L/uuPJh1hZFbcR8mewrx0d7JShr3F7pNW4vX0GRakKWVk7taDq7uPvFWw8YkMcPVb+vfvfRZ1i7zqFwjtmFouL72y6C/0L0Ie3GvaQXRyYVB3YZNE32/+A/D9bVLcRB3yw3hkRCdaDUtFl6Ykr20aaLvKoqIXUdbMj6GFzAmdxfWx9iIRrkDr1f27cFONGMUo/gRI/jNbIMYxJOoR1cY0OGaVPb5z9mlKbyJP/EsdmIXvsFmM7Ql42nEblX3xI1BbYbTkXCqRnxUbgzPo4T7sQBNeBG7zbAiDI8nWfZDhQWYCG4PFr+HMBQ6l5VPJybeRyJXwsdYJ/cRnlJV0yB4ZlUYtFQIkMZnst8fRrPcKezHCblz2IInMIkPzbbyb9mW42nWInc2xmE0y61AJ06oGsXL5rcOK1UdCbEXiVwNXsEy/6+EbaiVG8eeEAfxvaoSBnCH61uOD7BS1Ul8ESHBKWxCrdyd6EYNKihgEVrwOAbQruoytuBYIFfAc3gVN6iawhjKyNCEpYhVJXgbOzARyaU4hCtYizq5EI1YgiUoIlT1B7ZjByqmRWYbwtdYjoWoN7+LOIQefIqKawLzK6ID69GGpQgwhhEcwGGUzfEPAiPqsCXadFsAAAAASUVORK5CYII=)](https://github.com/intuit/auto)

![Release](https://github.com/kai-tub/external-repo-sync-action/workflows/Release/badge.svg)
![Update major tag](https://github.com/kai-tub/external-repo-sync-action/workflows/Update%20major%20tag/badge.svg)
![Unit Tests](https://github.com/kai-tub/external-repo-sync-action/workflows/Unit%20Tests/badge.svg)
![Verification Tests](https://github.com/kai-tub/external-repo-sync-action/workflows/Verification%20Tests/badge.svg)
</div>

- [When to use this action](#when-to-use-this-action)
  - [Automatically pushing to the repo's wiki](#automatically-pushing-to-the-repos-wiki)
  - [Updating and pushing to a different repository](#updating-and-pushing-to-a-different-repository)
- [When not to use the action](#when-not-to-use-the-action)
- [Set-Up](#set-up)
- [Inputs and Output](#inputs-and-output)
  - [Inputs](#inputs)
  - [Output](#output)
- [Examples](#examples)
  - [Using defaults](#using-defaults)
  - [Including different extensions](#including-different-extensions)
  - [Excluding different extensions](#excluding-different-extensions)
  - [Including and excluding different extensions](#including-and-excluding-different-extensions)
- [How it works](#how-it-works)
- [Security concerns/Implications](#security-concernsimplications)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

## STATUS: UNMAINTAINED

As I am no longer using the project, I have changed the status to `UNMAINTAINED` and archived the repository.
Feel free to fork the project!

Currently, the majority of the maintainence work would be updating GitHub action dependencies and moving the tutorial
and the internal CI pipeline to use the new [fine-grained personal access tokens](https://github.blog/2022-10-18-introducing-fine-grained-personal-access-tokens-for-github/).
The [fish shell](https://github.com/fish-shell/fish-shell) code is a thin wrapper around `git` and `rsync`.
It should be fairly easy to update the code or to move it to an easier scripting language, such as [nushell](https://www.nushell.sh/).

---

## When to use this action

You can use this action in two ways:

1. [Automatically push to the repo's wiki](#automatically-pushing-to-the-repos-wiki) (default setting)
2. [Update and push a different repository](#updating-and-pushing-to-a-different-repository)

## Automatically pushing to the repo's wiki

This action helps to push files *and* binaries
to the wiki of the current repository.
Instead of only pushing `.md`-files, which could be displayed
in the GitHub wiki, the wiki can also be re-used to serve as
a hosting solution for automatically generated files/binaries.

This is useful for repositories that need/want to display
the newest graphical changes or example images without
increasing the size of the repository. Or simply keep the
wiki up to date.

## Updating and pushing to a different repository

One can also specify a separate target repository instead of pushing specified files/binaries to the wiki of the current repository.
One can use this option if a separate developer/nightly 
repository and a stable/production repository exists..

# When not to use the action

If the goal is to modify and push to the existing repository, a different action
should be used, for example, [git-auto-commit-action](https://github.com/stefanzweifel/git-auto-commit-action)

# Set-Up

0. Enable your repository's wikis feature
    1. If you want to push to the wiki, you have to initialize 
    the wiki first.

       Go to the *Settings* of the repository and 
       under *Options* enable the *Wiki* *Feature*.

       ![Enable wiki](https://raw.githubusercontent.com/wiki/kai-tub/external-repo-sync-action/gifs/enable_wiki.gif)

   1. Add the first wiki page

      After enabling the wiki, go to the *Wiki* tab. 
      If not already done, create the first wiki page.

      ![Create wiki](https://raw.githubusercontent.com/wiki/kai-tub/external-repo-sync-action/gifs/create_wiki.gif)

1. A Personal Access Token has to be used.
    Go to the [Personal access token](https://github.com/settings/tokens) page and click on *Generate new token*.

    Location: *User icon* -> *Settings* -> *Developer settings* -> *Personal access tokens*

    Give it a name and enable all of the entries under *repo*.

    ![Create token](https://raw.githubusercontent.com/wiki/kai-tub/external-repo-sync-action/gifs/create_token_short.gif)
  
    Now click on *Generate token* and copy the *token* to your
    clipboard. The token will not be accessible again!

2. Finally, paste the personal access token from
your clipboard to the *GitHub secrets* of your project.

    Location: under the repo *Settings* -> *Secrets* -> *New secret*

    I would recommend naming it *GH_ACCESS_TOKEN* to have the
    same name for the variable and the action call.

    ![Add secret](https://raw.githubusercontent.com/wiki/kai-tub/external-repo-sync-action/gifs/add_secret.gif)

Now you are ready to use the action. :tada:

# Inputs and Output

## Inputs

As described in the set-up description, before you use the action, add a GitHub access token with repository rights to the repository secrets.
The remaining arguments of the script are the following:

- `source-directory`: The source directory which is the root for the patterns (Required)
- `repository`: Set which repository should be the target for the sync process.
By default, the wiki of the current repository is used.
- `user`: Set the user name configuration for the push. 
The default name is 
the triggering user
- `mail`: Set the email configuration for the push. 
Default mail is GitHub user `@users.noreply.github.com`
- `commit-message`: Set the commit-message for the push. 
Default is `Action Bot is pushing`.
- `branch`: Set which branch should be checked out. 
It never creates a new one. Default is master.
- `dry-run`: Doesn't touch repository. The command will run
in an empty folder. This shows what files will would be synced
with the repo without touching it. Default is false.
- `delete-missing`: Delete all files in the repo
that are not present in the source-directory. Please
be careful when using this option! Use `dry-run` to see
which files would be synced first. Default is false

Note: All commands and patterns are case-sensitive!
To include `*.JPG *.jpg`, please specify all desired variations. 

## Output

This action outputs the folder structure of the defined
repository after syncing. The output is mainly
used for testing.

- `sync_result`: Output variable name

# Examples

A couple of different examples on how to use the action:

## Using defaults

By default all files are synced from the docs
folder to the wiki of the current repository:

```yml
  jobs:
    sync_docs:
      name: Sync docs
      runs-on: ubuntu-latest
      steps:
        - name: Checkout current version
          uses: actions/checkout@v2
        - name: Create files to sync
          run: |
            mkdir docs/
            touch docs/hello.md
        - name: Sync with local action
          uses: kai-tub/external-repo-sync-action@v1
          with:
            source-directory: "./docs"
          env:
            GH_ACCESS_TOKEN: ${{ secrets.GH_ACCESS_TOKEN }}
```

With the resulting files in `docs`:
```
  .
  └── hello.md
```

## Including different extensions

To include multiple patterns, please use
spaces to separate them and place them in quotes.
The patterns are case-sensitive, and if *include*
is used, all other files are automatically excluded.
(This is *not* the default behavior of *rsync*)

With the following files in `docs`:
```
  .
  ├── folder_a
  │   ├── cat.jpg
  │   ├── cat_transparent.png
  │   └── dog.JPG
  ├── folder_b
  │   ├── README.md
  │   ├── result.pdf
  │   └── result.tmp.pdf
  ├── hello.md
  └── hello.png
```

And the following configuration:

```yml

  # Checkout repo and add files if necessary
  - name: Sync with include
    uses: kai-tub/external-repo-sync-action@v1
    with:
      source-directory: "./docs"
      include-patterns: "*.md *.jpg"
    env:
      GH_ACCESS_TOKEN: ${{ secrets.GH_ACCESS_TOKEN }}
```

With the resulting files in `docs`:
```
  .
  ├── folder_a
  │   └── cat.jpg
  ├── folder_b
  │   └── README.md
  └── hello.md
```


## Excluding different extensions

To exclude multiple patterns, please use
spaces to separate them and place them in quotes.
The patterns are case-sensitive.

With the following files in `docs`:

```
  .
  ├── folder_a
  │   ├── cat.jpg
  │   ├── cat_transparent.png
  │   └── dog.JPG
  ├── folder_b
  │   ├── README.md
  │   ├── result.pdf
  │   └── result.tmp.pdf
  ├── hello.md
  └── hello.png
```

And the following configuration:

```yml
  # Checkout repo and add files if necessary
  - name: Sync with exclude
    uses: kai-tub/external-repo-sync-action@v1
    with:
      source-directory: "./docs"
      exclude-patterns: "*.md *.jpg"
    env:
      GH_ACCESS_TOKEN: ${{ secrets.GH_ACCESS_TOKEN }}
```

With the resulting files in `docs`:

```
  .
  ├── folder_a
  │   ├── cat_transparent.png
  │   └── dog.JPG
  ├── folder_b
  │   ├── result.pdf
  │   └── result.tmp.pdf
  └── hello.png
```

## Including and excluding different extensions

To include/exclude multiple patterns, please use
spaces to separate them and place them in quotes.
The patterns are case-sensitive.

With the following files in `docs`:

```
  .
  ├── folder_a
  │   ├── cat.jpg
  │   ├── cat_transparent.png
  │   └── dog.JPG
  ├── folder_b
  │   ├── README.md
  │   ├── result.pdf
  │   └── result.tmp.pdf
  ├── hello.md
  └── hello.png
```

And the following configuration:

```yml
  # Checkout repo and add files if necessary
  - name: Sync with include and exclude
    uses: kai-tub/external-repo-sync-action@v1
    with:
      source-directory: "./docs"
      include-patterns: "*.pdf *.png"
      exclude-patterns: "*.tmp.pdf"
    env:
      GH_ACCESS_TOKEN: ${{ secrets.GH_ACCESS_TOKEN }}
```

With the resulting files in `docs`:

```
  .
  ├── folder_a
  │   └── cat_transparent.png
  ├── folder_b
  │   └── result.pdf
  └── hello.png
```

# How it works

The action is an *rsync* and *git* wrapper with some
sensible settings. The action only clones the specified branch
with a depth of 1 for better performance. As an *rsync* wrapper,
one limitation is the missing support for case-insensitive patterns,
but I decided *not* to add the feature, as NTFS filesystems are
case insensitive.

# Security concerns/Implications

As a security measure, forked repositories
cannot trigger workflows that use your GitHub access token. 
See [GitHub help](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)

Consequently, it is not straightforward to automatically push to the other repo or the wiki when merging branches from forks.
I suggest triggering on deploy events to a PR or, for a very hacky solution,
on a *manual* trigger, described in 
[dev.to](https://dev.to/s_abderemane/manual-trigger-with-github-actions-279e)

# License
This software is released under the GNU GPL v3.0 
[License](LICENSE).

# Contributing
Please see the [contribution guidelines](CONTRIBUTING.md) for more information.

As always, PRs are welcome. :)


# Contact
If you have any comments, issues, or suggestions, please
open an issue on GitHub. 
I try to help as much as I can. :)
