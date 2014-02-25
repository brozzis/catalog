SELECT rf.absolutePath || fo.pathFromRoot || fi.baseName || ‘.’ || fi.extension as fullName FROM Adobe_images ai
INNER JOIN AgLibraryCollection c ON ci.collection=c.id_local
INNER JOIN AgLibraryCollectionImage ci ON ai.id_local=ci.image
INNER JOIN AgLibraryFile fi ON ai.rootFile=fi.id_local
INNER JOIN AgLibraryFolder fo ON fi.folder=fo.id_local
INNER JOIN AgLibraryRootFolder rf ON fo.rootFolder=rf.id_local
WHERE c.name=’My Collection‘
ORDER BY 1



