####################################################################################################
###----------------------------------------------------------------------------------------------###
#                     \    ||   /
#      AA             \    ||   /  MMM    MMM  IIII  PPPPP
#     AAAA            \\   ||   /   MMM  MMM    II   P  PPP
#    AA  AA    ggggg  \\\\ ||  //   M  MM  M    II   PPPPP
#   AAAAAAAA  gg  gg     \\ ////    M      M    II   P
#  AA      AA  ggggg  \\   //      MM      MM  IIII  PPP
#                  g  \\\\     //
#              gggg      \\ ////     The Agricultural Model Intercomparison and Improvement Project
#                          //
###----------------------------------------------------------------------------------------------###
####################################################################################################
###----------------------------------------------------------------------------------------------###

### AgMIP Regional Integrated Assessment: Historical Simulation Possibility Exceedance Plot

# This routine is structured to produce CDF plot oF the historical crop yield related to DSSAT and APSIM. This rountine is used for Phase 2 of the EFID-funded regional integrated assessment.

# Created: October 26, 2015
# Last eidted: October 26, 2015
# Author: Wei Xiong, wei.xiong@ufl.edu
# Co-authors: Cheryl Porter, Sonali McDermid, and Alex Ruane
# Rountines are not gauranteed, and any help questions should be directed to the authors

HisCDF<-function(fileDir,pdfoutput){
    
    # List all ACMO files
    files <- list.files(fileDir,pattern="*\\.csv",full.names=T, recursive=FALSE)
    for(d in 1:length(files)){
      data <- read.csv(file=files[d],skip = 2, head=TRUE,sep=",") # This is for ACMO files that have a header above column names
      
      if (d==1){
         group<-"History"
         value<-data$HWAH
         dd0<-data.frame(group,value)
         group=data$CROP_MODEL[1]
         value=data$HWAH_S
         dd<-data.frame(group,value)
         dd0<-rbind(dd0,dd)
      }else{
         group=data$CROP_MODEL[1]
         value=data$HWAH_S
         dd<-data.frame(group,value)
         dd0<-rbind(dd0,dd)
      }
    }
    plottitle<-paste(data$CRID_text[1]," in ",data$REG_ID[1],sep="")
    dd<-NA
    group<-unique(dd0$group)
    r<-range(dd0$value,na.ram=TRUE)
    color<-c("black","red","blue","green") #
    pdf(pdfoutput)
    plot(0,xlim=c(r[1],r[2]),ylim=c(0,1),type="n",xlab="Yield (kg/ha)",ylab="Prob of Exceedance",main=plottitle)
    for (thisi in 1:length(group)){
            P<-ecdf(subset(dd0$value,dd0$group==group[thisi]))
            y=1-P(subset(dd0$value,dd0$group==group[thisi]))
            prob=sort(y,decreasing=TRUE)
            yields=sort(subset(dd0$value,dd0$group==group[thisi]),decreasing=FALSE)
            points(yields,prob,type="o",pch=20,col=color[thisi],lwd=2)
    }
    legend("topright",cex=0.75,pch=16,col=color,legend=group)
    dev.off()
}
options(echo=TRUE)
args<-commandArgs(trailingOnly=TRUE)
fileDir<-args[1]#"."
pdfoutput<-args[2]#"CDF.pdf"
HisCDF(fileDir,pdfoutput)