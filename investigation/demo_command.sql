#command list for generating a demo terminal output file
#this files contains both UNIX command and SQL

/*Connect to CS TEACHING LAB*/
#ssh <utorid>@dbsrv1.teach.cs.toronto.edu
ssh lishuoto@dbsrv1.teach.cs.toronto.edu

/*Load Database*/
cd ~/CSC343_Phase2
psql csc343h-lishuoto -f 'schema.ddl'
psql csc343h-lishuoto -f 'load_data.sql'
/*Start psql*/
cd ~/CSC343_Phase2/investigation
psql csc343h-lishuoto
