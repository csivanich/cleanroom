![Header](header.png)
======

###### Copy a repo and open a shell with a clean slate

------

Ever just need a quick peek at git repo's branch, but don't want to stash changes or worry about losing current work? if so, Cleanroom may be for you.

Cleanroom creates a temporary copy of your repository, checks out the requested branch, and opens a shell. When you're done, exit the shell, the temporary copy is deleted, and you're returned to the original repository.

Cleanroom was written to simplify my Ansible workflow --- where knowing a playbook's state is critical, I was tired of having to stash and unstash my changes throughout the day when I needed to orchestrate from the master branch. With `cleanroom`, this type of workflow is effortless:
```bash
# So many uncommitted changes
 c@einstein.wi1.sivanich.com ~/git/ansible: git status          [37-create-guacamole-server] +80 ~9 -18
# On branch 37-create-guacamole-server
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   group_vars/all
#       modified:   hosts
#       modified:   roles/git/tasks/main.yml
#       modified:   roles/guacserver/handlers/main.yml
#       modified:   roles/guacserver/tasks/main.yml
#       modified:   roles/guacserver/vars/main.yml
#       modified:   roles/java/tasks/main.yml
#       modified:   roles/tomcatserver/tasks/main.yml
#       modified:   roles/tomcatserver/vars/main.yml
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       group_vars/centos/
#       refresh_certs.yml
#       roles/guacserver/cred
#       roles/guacserver/templates/
#       roles/guacserver/vars/vault.yml
#       roles/tomcatserver/templates/server.xml.j2
#       site.yml
#       tmp-hosts
#       vault/
no changes added to commit (use "git add" and/or "git commit -a")

# Open a cleanroom of the master branch
 c@einstein.wi1.sivanich.com ~/git/ansible: cleanroom master    [37-create-guacamole-server] +80 ~9 -18
Creating cleanroom of 'ansible' (master) at '/tmp/tmp.uvAbwkyyQa/ansible-master'
...
# It does its thing
...
In ansible (master) cleanroom at /tmp/tmp.uvAbwkyyQa/ansible-master - exit to destroy
[chris@einstein ansible-master]$ git status
# On branch master
nothing to commit, working directory clean
...
# Do deploy, etc
...
[chris@einstein ansible-master]$ exit
exit
 c@einstein.wi1.sivanich.com ~/git/ansible:                     [37-create-guacamole-server] +80 ~9 -18
# Right back where we started
```
