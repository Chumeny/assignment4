#Set the Path
path<-path<-file.path("./UCI HAR Dataset"); #setting main path

#read data from files, previously downloaded and extracted
testactivity<-read.table(file.path(path,"test","y_test.txt"),header=FALSE); #read activity,features and subject
trainactivity<-read.table(file.path(path,"train","y_train.txt"),header=FALSE);
subjecttest<- read.table(file.path(path,"test","subject_test.txt"),header=FALSE);
subjecttrain<- read.table(file.path(path,"train","subject_train.txt"),header=FALSE);
featurestest<- read.table(file.path(path,"test","X_test.txt"),header=FALSE);
featurestrain<- read.table(file.path(path,"train","X_train.txt"),header=FALSE);



#merge test and train tables to set the complete data
features<-rbind(featurestest,featurestrain);
features<-as.numeric(features)
activity<-rbind(testactivity,trainactivity);
subject<-rbind(subjecttest,subjecttrain);

#label columns of tables to rearrange correct names
labelsfeatures<-read.table(file.path(path,"features.txt"),head=FALSE);
namesfeatures<-labelsfeatures$V2;
names(features)<-namesfeatures;
names(activity)<-"activity";
names(subject)<-"subject";

#merge three test/train tables in a complete data frame
maindata1<-cbind(subject,activity);
maindata<-cbind(maindata1,features);

#detect only std and means
namesmaindata<-names(maindata);
# unused line amesselection<-c(namesmaindata[1:3],namesmaindata[grep(("mean\\()|std()"),namesmaindata)])
selectioncolumns<-c(1:2,grep(("mean\\()|std()"),namesmaindata)); #columns vector construction

#construction selection mean and std selection
selection<-maindata[selectioncolumns];

#replace activity labels
#read activity labelsNAun
labelsactivity<-read.table("./UCI HAR Dataset/activity_labels.txt", head=FALSE);
#replace labels
maindata$activity<-factor(maindata$activity,labels=labelsactivity$V2);


#Rename variables from data set with descriptive variable name
namesmaindata<-gsub("^t","Time",namesmaindata);
namesmaindata<-gsub("^f","Frequency",namesmaindata);
namesmaindata<-gsub("Acc","Accelerometer",namesmaindata);
namesmaindata<-gsub("BodyBody","2Body",namesmaindata);
namesmaindata<-gsub("Gyro","Gyroscope",namesmaindata);
namesmaindata<-gsub("Mag","Magnitude",namesmaindata);
names(maindata)<-namesmaindata;

#clean names in selection table
names(selection)<-names(maindata)[selectioncolumns];

#create a second independent-tidy data set
dataclean<-aggregate(.~subject+activity,maindata,mean)
write.table(dataclean,file=tidycleandata.txt,row.name=FALSE)


