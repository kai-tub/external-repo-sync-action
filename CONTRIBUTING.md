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
If you modified the code or added tests, 
the tests have to pass before a PR can be merged.

If you are not familiar with creating a Pull Request, 
here are some guides:

- http://stackoverflow.com/questions/14680711/how-to-do-a-github-pull-request
- https://help.github.com/articles/creating-a-pull-request/

After passing the unit tests the verification tests have to pass.
As the secrets of the PR initiator is used, only collaborators
and the repository owner can trigger the verification step
automatically. The secret is needed to actually run the complete
action on the own repositories wiki. This will ensure that all
steps of the action are fully functional. 

Your PR code will be downloaded and verified manually before
merging.Please also read the [Code Of Conduct](./CODE_OF_CONDUCT.md)
before opening a PR.

After merging your PR you will be added to the list of contributors.

Thanks for your hard work and for sticking around until the end of the guide! :tada::tada::tada: