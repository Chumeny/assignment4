# assignment4
assignment for week 4:
The final file was generated cleaning data from UCI fit weareable file and will allow you summarize the data in averages for each variable

#First you should read all the tables:

#read data from files, previously downloaded and extracted
testactivity<-read.table(file.path(path,"test","y_test.txt"),header=FALSE); #read activity,features and subject
trainactivity<-read.table(file.path(path,"train","y_train.txt"),header=FALSE);
subjecttest<- read.table(file.path(path,"test","subject_test.txt"),header=FALSE);
subjecttrain<- read.table(file.path(path,"train","subject_train.txt"),header=FALSE);
featurestest<- read.table(file.path(path,"test","X_test.txt"),header=FALSE);
featurestrain<- read.table(file.path(path,"train","X_train.txt"),header=FALSE);

#Then you merge test and train tables to set the complete data>

features<-rbind(featurestest,featurestrain);
features<-as.numeric(features)
activity<-rbind(testactivity,trainactivity);
subject<-rbind(subjecttest,subjecttrain);


#Label columns of tables to rearrange correct names:


labelsfeatures<-read.table(file.path(path,"features.txt"),head=FALSE);
namesfeatures<-labelsfeatures$V2;
names(features)<-namesfeatures;
names(activity)<-"activity";
names(subject)<-"subject";


#Merge three test/train tables in a complete data frame:

maindata1<-cbind(subject,activity);
maindata<-cbind(maindata1,features);



#Detect only std and means:

namesmaindata<-names(maindata);
selectioncolumns<-c(1:2,grep(("mean\\()|std()"),namesmaindata)); #columns vector construction

#Construction selection mean and std selection
selection<-maindata[selectioncolumns];

#Replace activity labels

labelsactivity<-read.table("./UCI HAR Dataset/activity_labels.txt", head=FALSE);

#Replace labels
maindata$activity<-factor(maindata$activity,labels=labelsactivity$V2);

#Clean names in selection table
names(selection)<-names(maindata)[selectioncolumns];

#Create a second independent-tidy data set

dataclean<-aggregate(.~subject+activity,maindata,mean)
write.table(dataclean,file=tidycleandata.txt,row.name=FALSE)


