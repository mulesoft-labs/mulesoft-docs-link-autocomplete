= AsciiDoc Link Autocomplete

This is a package for Atom that reads a CSV file of links and displays those links in a drop-down menu when you start typing `link:`. 

== How to Install

[TIP]
Make sure you that you've enabled hidden folders, otherwise you won't be able to see the *.atom* folder in your user directory.

. Either clone this repository or download a .zip file of its contents.
. Put the entire package folder in the *user.name/.atom/packages* folder.
. If Atom is already running, restart it. A restart is required to active the new plugin, which will be automatically installed.
. After restarting Atom, click on *Atom* > *Preferences* from the top menu.
. In the *Preferences* menu, click *Install*, and then search for `language-asciidoc`. Install the package. This is a required prerequisite for the following link autocomplete package.
. In the *Preferences* menu, click *Packages* and look under *Community Packages*. You'll see the *mulesoft-docs-link-autocomplete* package, which should show as installed and enabled.
+
[NOTE]
You may get a warning message about the CSV file not existing. This error is expected because you need to provide the local path to the CSV file where the package will read link data.
+
. Navigate to the *../lib/provider.coffee* file in the package folder. You will need to edit this file with an updated path to the CSV file.
. The *provider.coffee* file starts with the following variable declaration, which needs to be changed with the proper path of the CSV file:
+
[source]
----
csvPath = "../content_list.csv"
----
+
. Once you've declared the new path to the CSV file, you can start using the package.

== How to Use

. Once the package has been installed, simply start typing `link:` in an adoc file, and whatever text follows will be searched in the CSV file. 
. Once you've found the entry you're looking for, press *Enter*. 
+
[IMPORTANT]
Due to a bug, currently you'll have to delete the text you started typing.
