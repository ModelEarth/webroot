# How to deploy changes

Update and make commits often. (At least hourly if you are editing code.)
Append "nopr" or "No PR" if you are not yet ready to send a Pull Request.

## Using git.sh (Recommended)

Run your git.sh commands from a separate terminal. (Otherwise Code CLIs tend to use their own "push" interpretations.)

Start a secure virtual session in your local webroot and give the git.sh files permission.  
You can run ./git.sh from the root of your webroot.  (It resides in the team submodule to share among sites.)

	python3 -m venv env
	source env/bin/activate
	chmod +x git.sh
	chmod +x team/git.sh

You can watch your webroot's file status change in Github Desktop to confirm updates are deployed.

	./git.sh push           # Push all repositories with changes (auto-pulls first)
	./git.sh pull           # Pull all repositories (webroot + submodules + extra repos)
	./git.sh push [name]    # Push specific repository (webroot, submodule, or extra repo)
	./git.sh pull [name]    # Pull specific repository

You probably won't need these since cmds above resolve detached heads for submodules that differ from their parent repos.

	./git.sh fix                    # Fix detached HEAD states
	./git.sh remotes                # Update remotes for current GitHub user

"push" also sends a Pull Request (PR) unless you include "nopr" 

### Wait to submit Pull Request:
- Add `nopr` to skip PR creation: `./git.sh push nopr`

<!-- 
Advanced option (not recommended for typical use):
- Add `overwrite-local` to let parent repository override your local commits: `./git.sh pull overwrite-local`

WARNING: `overwrite-local` will delete local work in submodules:
- Uncommitted changes: Permanently lost, no recovery possible
- Committed but unpushed changes: Can be recovered using git's reflog

To recover previously committed work that was overwritten locally:
	cd [submodule_name]
	git reflog                    # Find your lost commit hash
	git checkout [commit_hash]    # Restore your work
	git checkout -b recovery      # Create new branch to save it
-->

### Supported repositories:
- **Webroot**: webroot
- **Submodules**: Automatically detected from .gitmodules file
- **Extra Repos**: Automatically detected from extra-repos.txt file

## Using Github Desktop

You can also use Github Desktop to choose a repo in the webroot using "File > Add Local Repository". 
Then submit a PR through the Github.com website. (The "push" with Claude or git.sh will send a PR automatically.)

IMPORTANT: If you're using Github Desktop to push, you'll probably still need to send a PR in Github.com.


## Using Claude Code CLI with git.sh (so so)

We don't use Claude with git.sh frequently because Claude doesn't always find the webroot smoothly, and sometimes starts following its own Github steps - which can require numerous approvals.

For the first usage, include extra guidance:

	push using claude.md with git.sh  


If you find "push" is asking for multiple approvals, Claude isn't following its CLAUDE.md instructions.
When CLAUDE.md is followed, "push" uses the git.sh file to first pull, then update the webroot, submodules and forks.

	push

Additional deployment commands:

	push [folder name]  # Deploy a specific submodule or fork
	push submodules  # Deploy changes in all submodules
	push forks  # Deploy the extra forks added

"push" also sends a Pull Request (PR) unless you include "nopr" 


## Manual submodule refresh

You can refresh all your local submodules by running:

	git submodule foreach 'git pull origin main || git pull origin master'