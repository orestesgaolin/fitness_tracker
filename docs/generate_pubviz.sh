pubviz --format=dot print -d -p -i flutter,animations,intl,flutter_localizations,path_provider,path,bloc,flutter_bloc,equatable,collection >output.dot
dot -Tpng output.dot -o docs/structure.png
rm output.dot
