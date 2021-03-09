beta-project

** Important note
Automation studio doesn't like git cleaning up files, because the background process 
will keep a write-lock on, even if you close Automation Studio.  
To fix this, for now at least, seems to force it through command-line.  
Open a PowerShell promt as Admin, and navigate to the folder:  
*\beta-project\automationstudio\Logical\*  
Run the following line:  
*rmdir -R -Force .\* *  
Pull what ever branch you tried to pull again.  

** Structure
* master
Latest fully tested build  

* test
In-review before merging with master

* features
Each in-progress feature should have a specific development branch. 
This branches from the **master** and ends up merged into **test**

** Procedure
* Starting new feature
Checkout the latest master branch. Create a new branch, *feature*-**xxxxxx**.
Remember to push your new branch to the repo.

* Starting new feature, but it depends on a thing in test?
Create a new *feature-branch* from test instead.

* Updating an unfinished feature branch to the latest master
Push any changes to your *feature-branch*.  
Checkout the **master** branch and pull the latest.  
Right-click on your *feature-branch* and select **Rebase feature-branch onto master**  
This recreates your *feature-branch* history with the latest master as the base. 
Any merge conflicts **must** be handled here.  
It is **always** a *Force Push*, that's just because it's a rebase instead of merge.

* Merging a finished feature branch into test
Push any changes to your *feature-branch*.
Checkout the **test** branch and pull the latest.  
Right-click on your *feature-branch*, select **Rebase feature-branch onto test**.  
This recreates your *feature-branch* history with the latest test as the base. 
Any merge conflicts **must** be handled here. 
It is **always** a *Force Push*, that's just because it's a rebase instead of merge. 
Finally checkout **test** and right-click on *feature-branch* and select **Fast-forward test to feature-branch**

* Merging test into master
We all agree to it, and merge **test** into **master**. Note this is not a rebase, 
only *feature-branches* should be rebased.