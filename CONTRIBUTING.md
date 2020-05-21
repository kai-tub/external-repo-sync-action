# Contributing to the External repository sync action
This action is a community effort, and everyone is welcome to contribute!

If you are interested in contributing, there are many ways to help out:
1. It helps us very much if you could
   - Report issues you're facing
   - Give a :+1: on issues that others reported and that are relevant to you
   - Spread the word about the project or :star: to say "I use it!"
2. You would like to improve the documentation. 
Improving the documentation is no less important 
than improving the code itself!
If you find a typo in the documentation, do not hesitate to submit a GitHub pull request.
3. You would like to propose a new feature and implement it
   - Choose the corresponding issue template and fill out the required information. Once we agree that the plan looks good,
   go ahead, and implement it.

## PR guide
If you modified the code or added tests, a couple of
steps must be done before a PR can be merged.
As the action requires a secret token, the tests *will not*
work without any extra steps. The tests need access to
the wiki of the forked repository. Do the
same steps described in the Set-Up section of the 
[README.md](README.md). The tests are more similar to
*verification* steps instead of unit tests.
They are designed to check the full functionality,
from checking out to pushing to a different branch.

After adding a secret called `GH_ACCESS_TOKEN`
(for the tests this name *has* to be used!) and activating/pushing
to the wiki, the wiki has to be checkout out. 
Now two *empty* branches have to be
create; one called `tests` and one called `test_push_to_branch`.

These steps could be executed with:
```bash
   git clone https://github.com/<USERNAME>/external-repo-sync-action.wiki.git
   cd external-repo-sync-action.wiki/
   git checkout -b tests
   rm -rf * # Make sure branche is empty
   git add . && git commit -m "Added test branch"
   git push -u origin tests
   # repeat for test_push_to_branch branch
   git checkout -b test_push_to_branch
   rm -rf *
   git add . && git commit -m "Added push test branch"
   git push -u origin test_push_to_branch
```

After doing all of the steps described above,
the tests will *fail* on the PR site. This is
due to how GitHub Actions are triggered and what
environment variables they can access. The
PR commit will try to get the secret from the
original repository, which is *hidden* for obvious
security risks. *But* the tests will run in
your forked repository. The status of these tests
is used to decide if the PR can be merged or not.

These steps are an inconvenience, but with this
approach, the functionality can be verified for all users.
(May change in the future)

If you are not familiar with creating a Pull Request, here are some guides:
- http://stackoverflow.com/questions/14680711/how-to-do-a-github-pull-request
- https://help.github.com/articles/creating-a-pull-request/

Please also read the [Code Of Conduct](./CODE_OF_CONDUCT.md)
before opening a PR.
After merging your PR you will be added to the list of contributors.

Thanks for your hard work and for sticking around until the end of the guide! :tada::tada::tada: