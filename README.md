Dotfiler — the ultimate solution for managing dotfiles!
=======================================================

[![changelog](http://allmychanges.com/p/python/dotfiler/badge/)](http://allmychanges.com/p/python/dotfiler/?utm_source=badge)

This was inspired by [Zach Holman's dotfiles](https://github.com/holman/dotfiles) and
[homesick](https://github.com/technicalpickles/homesick), but was made according the KISS priciple.

There are very few commands in dotfiler, only: `update`, `add` and `status`:

* `update` will pull from all version controlled envs (env is a subdirectory inside
  the `~/.dotfiles` dir, where different configs and scripts could be placed). After that,
  `update` will make all that mumbo-jumbo, symlinking, and removing old broken symlinks.
  If you want to see what will it do without but afraid to loose some files, just fire
  `dot update --dry --verbose`.
* `add` allows you to clone one or more repositories with configs. For example, this
  will clone my emacs's configs: `dot add svetlyak40wt/dot-emacs`. Of course you could
  use a full url, like this: <https://github.com/svetlyak40wt/dot-emacs> or
  <git@github.com:svetlyak40wt/dot-emacs.git>.
* `status` will show you if there are any uncommited changes in the envs and
  warn you if some of them aren't version controlled.

Installation
------------

1. Clone this project somewhere like `$HOME/.dotfiles` and add `$HOME/.dotfiles/bin` into your `PATH`.
2. Clone some config files into the `$HOME/.dotfiles`.
3. Run `dot update` to make all necessary symlinks.
4. Have a profit!

Overview
------------

From user's point of view — very simply. You just create a separate subdirectory called "environments", put configs there and then run `dot update`. Dotfiler will make all necessary symlinks automagickally. **What makes dotfiler better, than other solutions?** It's ability to merge files from different environments into one target dir. Here's an example:

Suppose, you have a `~/.zshrc` which sources all configs from `~/.zsh/`. And you want to separate default configs from the configs only needed on work machines. In most config managers you will end up with two separate repositories, each sharing part of zsh config. But dotfiler allows you to do a much more clever thing — separate zsh (actually any other configs too, if they understand `include`) into the different environments.

In this example:

* The first environment, let's call it `base`, will contain the file `base/.zsh/generic`.
* The second environment, called `atwork`, will have `atwork/.zsh/secret-settings`. 

Both of them, of course, could include other files, not only zsh configs. Most importantly, these environment now can be stored separately and installed on each machine separately. Now, you can share you default configs on the GitHub, but keep work configs in a separate, private repository. 

You can also add new environments using `dot add <url> <url>...`. (Probably the process of adding environments on a fresh machine will be even more improved, when I introduce a 'meta-environments', which will allow you to make one env depend on other envs and pull them automatically when adding)

Get involved
------------

Don't hesitate to try dotfiler. Just install it and make your configs more structured.  Extract useful ones and share them on GitHub, as I did. Then send me a link with a short description (or make a pull request), and I'll add you repositories to the end of this page.

Dotfiler's core functionality is fully tested, but that doesn't mean there aren't bugs. If you find one, file the issue on Github, or even better, try to write a test and/or fix for that use case and send it as a pull request. To run all tests, install nose and run `nosetests bin/lib/dot`. 

How it works
------------

First dotfiler, walks through all files and all environments collecting dirs and files mentioned in more than one environment as a tree. If a file with same filename exits in more than one environment this is an error and `dot` will tell you they are conflicting. 

Then, using this tree, it generates source—target pairs, where source is a file inside the environment dir and target is where it should be in your home dir. 

Finally, `dot` generates actions for each pair. Actions could be `rm`, `mkdir`, `link`, `already-linked` and `error`. Action are generated based on the current file system's state and previously generated actions. Here is a simple example:

This is a structure of the `~/.dotfiles` with two separate enviroments `zsh` and `emacs`:

```
.
├── emacs
│   └── .emacs.d
│       ├── .gitignore
│       ├── COPYING
│       ├── README.markdown
│       ├── art
│       │   ├── debian-changelog-mode.el
│       │   ├── lisp.el
│       │   ├── multiple.el
│       │   ├── my-org.el
│       │   ├── my-python.el
│       │   └── pymacs.el
│       ├── art.el
│       ├── changelog.md
│       ├── customizations.el
│       ├── init.el
│       ├── modules
│       │   ├── starter-kit-bindings.el
│       │   ├── starter-kit-eshell.el
│       │   ├── starter-kit-js.el
│       │   ├── starter-kit-lisp.el
│       │   ├── starter-kit-perl.el
│       │   └── starter-kit-ruby.el
│       ├── snippets
│       │   └── python-mode
│       │       └── pdb.yasnippet
│       ├── starter-kit-defuns.el
│       ├── starter-kit-misc.el
│       ├── starter-kit-pkg.el
│       ├── starter-kit.el
│       ├── tar.sh
│       ├── ubuntu -> art
│       ├── ubuntu.el -> art.el
│       ├── vagrant -> art
│       └── vagrant.el -> art.el
└── zsh
    ├── .bash_profile
    ├── .zsh
    │   ├── 00-options
    │   ├── 01-prompt-functions
    │   ├── 02-prompt-colors
    │   ├── 03-prompt
    │   ├── aliases
    │   ├── ash
    │   ├── dotfiler
    │   └── ssh-agent
    └── .zshrc
```

And here is result of `dot update`:

```
[art@art-osx:~/.dotfiles]% dot update
LINK    Symlink from /home/art/.bash_profile to /home/art/.dotfiles/zsh/.bash_profile was created
LINK    Symlink from /home/art/.emacs.d to /home/art/.dotfiles/emacs/.emacs.d was created
LINK    Symlink from /home/art/.zsh to /home/art/.dotfiles/zsh/.zsh was created
LINK    Symlink from /home/art/.zshrc to /home/art/.dotfiles/zsh/.zshrc was created
```

As you can see, dotfiler creates four symlinks, two to files, and two to directories. But this was simple situation
with no overlapping subdirectories.

Here is another example, showing how config merging works:

```
.
├── git
│   ├── .gitconfig
│   └── .zsh
│       ├── git-aliases
│       └── git-prompt
└── zsh
    ├── .bash_profile
    ├── .zsh
    │   ├── 00-options
    │   ├── 01-prompt-functions
    │   ├── 02-prompt-colors
    │   ├── 03-prompt
    │   ├── aliases
    │   ├── ash
    │   ├── dotfiler
    │   └── ssh-agent
    └── .zshrc
```

In this case, we have two environments and both of them have configs for zsh. For this situation,
dotfiler will try to create a directory `~/.zsh` and will make symlinks there:

```
[art@art-osx:~/.dotfiles]% dot update
LINK    Symlink from /home/art/.bash_profile to /home/art/.dotfiles/zsh/.bash_profile was created
LINK    Symlink from /home/art/.gitconfig to /home/art/.dotfiles/git/.gitconfig was created
MKDIR   Directory /home/art/.zsh was created.
LINK    Symlink from /home/art/.zsh/00-options to /home/art/.dotfiles/zsh/.zsh/00-options was created
LINK    Symlink from /home/art/.zsh/01-prompt-functions to /home/art/.dotfiles/zsh/.zsh/01-prompt-functions was created
LINK    Symlink from /home/art/.zsh/02-prompt-colors to /home/art/.dotfiles/zsh/.zsh/02-prompt-colors was created
LINK    Symlink from /home/art/.zsh/03-prompt to /home/art/.dotfiles/zsh/.zsh/03-prompt was created
LINK    Symlink from /home/art/.zsh/aliases to /home/art/.dotfiles/zsh/.zsh/aliases was created
LINK    Symlink from /home/art/.zsh/ash to /home/art/.dotfiles/zsh/.zsh/ash was created
LINK    Symlink from /home/art/.zsh/dotfiler to /home/art/.dotfiles/zsh/.zsh/dotfiler was created
LINK    Symlink from /home/art/.zsh/git-aliases to /home/art/.dotfiles/git/.zsh/git-aliases was created
LINK    Symlink from /home/art/.zsh/git-prompt to /home/art/.dotfiles/git/.zsh/git-prompt was created
LINK    Symlink from /home/art/.zsh/ssh-agent to /home/art/.dotfiles/zsh/.zsh/ssh-agent was created
LINK    Symlink from /home/art/.zshrc to /home/art/.dotfiles/zsh/.zshrc was created
```

How to ignore some files
========================

Edit a config file `~/.dotfiles/.dotignore` and add any regex patterns you need.

Environments
------------

* [svetlyak40wt/dot-emacs](https://github.com/svetlyak40wt/dot-emacs) — my emacs config, based on [Emacs Starter Kit](http://github.com/technomancy/emacs-starter-kit).
* [svetlyak40wt/dot-zsh](https://github.com/svetlyak40wt/dot-zsh) — generic config for zsh, which sources all config files from `~/.zsh` directory.
* [svetlyak40wt/dot-tmux](https://github.com/svetlyak40wt/dot-tmux) — config and python wrapper for tmux.
* [svetlyak40wt/dot-git](https://github.com/svetlyak40wt/dot-git) — config and shell aliases for git.
* [svetlyak40wt/dot-helpers](https://github.com/svetlyak40wt/dot-helpers) — misc command line helpers (see repo's README for full list).
* [svetlyak40wt/dot-osx](https://github.com/svetlyak40wt/dot-osx) — OSX keybindings and settings.
* [svetlyak40wt/dot-python-dev](https://github.com/svetlyak40wt/dot-python-dev) – emacs, zsh and pudb settings for Python developement.
* [svetlyak40wt/dot-growl](https://github.com/svetlyak40wt/dot-growl) – A helper to use growl notifications from ssh sessions.
* [svetlyak40wt/dot-lisp](https://github.com/svetlyak40wt/dot-lisp) – Dotfiler's config for Lisp development. 
* [svetlyak40wt/dot-osbench](https://github.com/svetlyak40wt/dot-osbench) – A helper to setup PATH to [OSBench's](https://github.com/svetlyak40wt/osbench) bin directory.

Another solutions
-----------------

* [skeswa/dotfiler](https://github.com/skeswa/dotfiler) – another utility with the same name but completely different approach.
# .dotfiles
