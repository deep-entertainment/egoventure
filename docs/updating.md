# Updating EgoVenture

The main EgoVenture functionality is distributed as Godot addons. Addons can be simply updated by downloading the new version and overwriting the existing files.

**Warning**: If you use EgoVenture, you should **never** change files inside the following folders to be able to update to newer versions:

* `addons/egoventure`
* `addons/parrot`
* `addons/speedy_gonzales`

Before you start updating make sure, that you have a *current backup of your game*. Also, *read the release notes* of all intermediate releases from your current version to the version you want to update to. You can find the release notes in the following places:

- [EgoVenture](https://github.com/deep-entertainment/egoventure/releases)
- [Parrot](https://github.com/deep-entertainment/parrot/releases)
- [Speedy Gonzales](https://github.com/deep-entertainment/speedy_gonzales/releases)

Especially look for notes regarding dependency updates (e.g. From EgoVenture 0.24.0 on, Parrot 0.7.0 is required)

To update, switch to the Godot AssetLib view:

![Opening the asset lib](images/update_assetlib.png)

Then, search for the addon you want to update (EgoVenture, Parrot or Speedy Gonzales):

![image-20210613143110407](images/update_searching.png)

Click on the name of the Addon (EgoVenture in this example) to see some information about it:

![The addon informations](images/update_infos.png)

Check, that the given version is the one you'd like to update to (0.18.0 in this example). Click "Download". The addon will be downloaded now. Wait until it's finished:

![The addon is downloaded](images/update_download.png)

Click "Install..." 

The next part is currently very cumbersome. First, remove the check mark at the topmost entry in the package installer:

![Unckeck the checkmark at res://](images/update_installer1.png)

Then select **every** folder and file inside the Addons' path (addons/egoventure in this example). This is because you the files already exists and Godot requires you to check all files that it should overwrite.

![Checking every addon checkmark](images/update_installer2.png)

After that, click "Install" and the update will be installed.
