beta-project

** Important note
Automation studio doesn't like git cleaning up files. 
To fix this, 

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

* Updating an unfinished feature branch to the latest master
Push any changes to your *feature-branch*.  
Checkout the **master** branch and pull the latest.  
Right-click on your *feature-branch* and select **Rebase feature-branch onto master**  
This recreates your *feature-branch* history with the latest master as the base. 
Any merge conflicts **must** be handled here.

* Merging a finished feature branch into test
Push any changes to your *feature-branch*.
Checkout the **test** branch and pull the latest.  
Right-click on your *feature-branch* and select **Rebase feature-branch onto test**  
This recreates your *feature-branch* history with the latest test as the base. 
Any merge conflicts **must** be handled here.

* Merging test into master
