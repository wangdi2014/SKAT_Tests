## Rscript to Make Manhattan Plots for the Genes Analyzed in this Pipeline ##
## April 3, 2014 ##
## Kristopher Standish ##

## Name: Gene_Manhattan.R

## Usage: Rscript Gene_Manhattan.R ${NEW_GENE_LIST} ${COV_FILE} ${PHENO_TYPE}

LINE <- commandArgs(trailingOnly = TRUE)
# LINE <- c("/home/kstandis/MrOSexome/20140612_TEST_GENES_Quant_Pheno/Alt_TEST_GENES.txt", "F", "C")
# LINE <- c("/home/kstandis/MrOSexome/20140613b_2012_GWAS_Tb2_Quant_Pheno/Alt_2012_GWAS_Tb2.txt", "F", "C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140616_2014_Plenge_LT8_DEL_28_BL_DAS_BL_AGE_SEX_PC1_PC2/Alt_2014_Plenge.txt", "/projects/janssen/ASSOCIATION/PH-PHENOTYPES/COV.txt","C")
# LINE <- c("/projects/ps-jcvi/projects/Kidney/20140506_Test_SKAT_Cap_Reject/Alt_Test_SKAT_Cap.txt","F")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140617_2014_Plenge_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_2014_Plenge.txt","/projects/janssen/RV_Rare_Variant/20140617_2014_Plenge_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140815b_CHR_1_UNIQ.list.aa_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_CHR_1_UNIQ.list.aa","/projects/janssen/RV_Rare_Variant/20140815_CHR_1_UNIQ.list.aa_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140815_CHR_11_UNIQ_am_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_CHR_11_UNIQ_am","/projects/janssen/RV_Rare_Variant/20140815_CHR_11_UNIQ_am_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140820_CHR_X_UNIQ_ag_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_CHR_X_UNIQ_ag","/projects/janssen/RV_Rare_Variant/20140820_CHR_X_UNIQ_ag_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140908_CHR_X_UNIQ_aa_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_CHR_X_UNIQ_aa","/projects/janssen/RV_Rare_Variant/20140908_CHR_X_UNIQ_aa_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140908_CHR_Y_UNIQ_aa_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_CHR_Y_UNIQ_aa","/projects/janssen/RV_Rare_Variant/20140908_CHR_Y_UNIQ_aa_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
# LINE <- c("/projects/janssen/RV_Rare_Variant/20140908_CHR_15_UNIQ_ac_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Alt_CHR_15_UNIQ_ac","/projects/janssen/RV_Rare_Variant/20140908_CHR_15_UNIQ_ac_LT8_DEL_MNe_MN_DAS_BL_MN_AGE_SEX_PC1_PC2/Cov_w_PCs.txt","C")
PathToGeneList <- LINE[1]
Split <- strsplit(PathToGeneList,"/")
PathToAssoc <- paste(Split[[1]][1:(length(Split[[1]])-1)],collapse="/")
DirName <- Split[[1]][length(Split[[1]])-1]
PathToCovFile <- LINE[2]
PHENO_TYPE <- LINE[3]

#########################################################
## LOAD DATA ############################################
#########################################################
## Specify Suffix for Files
if (PHENO_TYPE=="C") { 
	Asc_Sfx <- ".assoc.linear" }
if (PHENO_TYPE=="B") { 
	Asc_Sfx <- ".assoc.logistic" }

## Load Gene List
GENE_LIST <- read.table(PathToGeneList)

## P-value files for each gene
FULL <- FUNC_POS <- DAMG_POS <- list()
for (gene_num in 1:nrow(GENE_LIST)) {
	GENE <- as.character(GENE_LIST[gene_num,])
	PathToPlinkFiles <- paste(PathToAssoc,"/",GENE,"/PLINK_FILES/PLINK_",GENE,sep="")
	if (file.exists(paste(PathToPlinkFiles,Asc_Sfx,sep=""))==T) { 
		FULL[[gene_num]] <- read.table(paste(PathToPlinkFiles,Asc_Sfx,sep=""),header=T)
		names(FULL)[gene_num] <- as.character(GENE_LIST[gene_num,1]) }
	if (file.exists(paste(PathToAssoc,"/",GENE,"/",GENE,".Func.list",sep=""))==T) { 
		if (length(readLines(paste(PathToAssoc,"/",GENE,"/",GENE,".Func.list",sep="")))>0) {
			FUNC_POS[[gene_num]] <- read.table(paste(PathToAssoc,"/",GENE,"/",GENE,".Func.list",sep=""))
			names(FUNC_POS)[gene_num] <- as.character(GENE_LIST[gene_num,1]) } }
	if (file.exists(paste(PathToAssoc,"/",GENE,"/",GENE,".Damg.list",sep=""))==T) { 
		if (length(readLines(paste(PathToAssoc,"/",GENE,"/",GENE,".Damg.list",sep="")))>0) {
			DAMG_POS[[gene_num]] <- read.table(paste(PathToAssoc,"/",GENE,"/",GENE,".Damg.list",sep=""))
			names(DAMG_POS)[gene_num] <- as.character(GENE_LIST[gene_num,1]) } }
}

## Chromosome Length Table
lens <- read.table(file="/home/kstandis/RV/Tools/Chrom_Lengths.txt", sep="\t", header=T, stringsAsFactors=F)

## Get rid of genes w/o any variants
FULL <- FULL[which(as.numeric(summary(FULL)[,1])!=0)]
if (length(FUNC_POS)!=0) { FUNC_POS <- FUNC_POS[which(as.numeric(summary(FUNC_POS)[,1])!=0)] }
if (length(DAMG_POS)!=0) { DAMG_POS <- DAMG_POS[which(as.numeric(summary(DAMG_POS)[,1])!=0)] }

#########################################################
## PLOT THIS SHIZ #######################################
#########################################################

## Make Manhattan plot and QQ plot for each

## Pull out best p-value for each gene
BEST_P <- numeric(length(FULL))
names(BEST_P) <- names(FULL)
for (gene_num in 1:length(FULL)) { BEST_P[gene_num] <- min(FULL[[gene_num]]$P) }

## Pull out coordinates that meet specific threshold
THRESH <- 0.1
for (gene_num in 1:length(FULL)) {
	COMP_ARR <- 0
	GENE <- names(FULL)[gene_num]
#	print(paste("$$$$$$$",GENE,"$$$$$$$"))
	DATA <- FULL[[gene_num]]
#	print(head(DATA,1))
	if (length(dim(DAMG_POS[[GENE]]))>0) { colnames(DAMG_POS[[GENE]]) <- c("CHR","BP") }
	COMP_ARR <- rbind( DATA[which(DATA$P < THRESH),c("CHR","BP")], DAMG_POS[[GENE]] )
#	print(dim(COMP_ARR))
#	print(dim(DAMG_POS[[GENE]]))
	if ( nrow(COMP_ARR) > 0 ) {
		WRITE_TAB <- COMP_ARR
		PathToSave <- paste(PathToAssoc,"/",GENE,"/",GENE,".Thrsh.list",sep="")
		# print(PathToSave)
		write.table(WRITE_TAB, PathToSave, row.names=F, col.names=F, sep="\t", quote=F)
	}
	else { print(paste(GENE,"has no Variants Beyond",THRESH)) }
}

## Loop it for each gene to Compile into single array
 # FULL set
print("Compiling P-Values and Coordinates for FULL Set")
P_FULL <- FULL[[1]]
for (gene_num in 2:length(FULL)) {
	GENE <- names(FULL)[gene_num]
	P_FULL <- rbind(P_FULL,FULL[[GENE]])
}
N_Vars <- nrow(P_FULL)
P_FULL_ID <- paste(P_FULL$CHR,P_FULL$BP,sep=":")
P_FULL_ID <- gsub("23:","X:",P_FULL_ID)
P_FULL_ID <- gsub("24:","Y:",P_FULL_ID)
 # FUNC set
print("Compiling P-Values and Coordinates for FUNC Sets")
if (length(FUNC_POS)!=0) { 
	POS_FUNC <- paste(FUNC_POS[[1]][,1],FUNC_POS[[1]][,2],sep=":")
	for (gene_num in 2:length(FULL)) {
		GENE <- names(FULL)[gene_num]
		POS_FUNC <- c(POS_FUNC,paste(FUNC_POS[[GENE]][,1],FUNC_POS[[GENE]][,2],sep=":"))
	}
	P_FUNC <- P_FULL[which(P_FULL_ID %in% POS_FUNC),]
	if ( nrow(P_FUNC)==0 ) { P_FUNC <- "None" }
} else { P_FUNC <- "None" }
 # DAMG set
print("Compiling P-Values and Coordinates for DAMG Sets")
if (length(DAMG_POS)!=0) { 
	POS_DAMG <- paste(DAMG_POS[[1]][,1],DAMG_POS[[1]][,2],sep=":")
	for (gene_num in 2:length(FULL)) {
		GENE <- names(FULL)[gene_num]
		POS_DAMG <- c(POS_DAMG,paste(DAMG_POS[[GENE]][,1],DAMG_POS[[GENE]][,2],sep=":"))
	}
	P_DAMG <- P_FULL[which(P_FULL_ID %in% POS_DAMG),]
	if ( nrow(P_DAMG)==0 ) { P_DAMG <- "None" }
} else { P_DAMG <- "None" }

## Set up variables for plotting/naming/etc...
Set_Range <- max(10, ceiling(-log10(min(P_FULL$P,na.rm=T))) ,na.rm=T)
COLS_1 <- rep(c("chartreuse3", "dodgerblue2"),12)
COLS_2 <- c("goldenrod1","firebrick2")

## Make Manhattan Plot
print("Time to Plot the Skyline")
# CHROMS <- c(1:22,"X","Y")
# Y_LIM <- c(0,3e9)
if (P_FULL$CHR[1]!=P_FULL$CHR[nrow(P_FULL)]) { 
	X_LIM_MN <- lens[P_FULL$CHR[1],3] ; X_LIM_MX <- lens[P_FULL$CHR[nrow(P_FULL)],3]
	X_LABEL <- "Chromosome"
}
if (P_FULL$CHR[1]==P_FULL$CHR[nrow(P_FULL)]) {
	X_LIM_MN <- lens[P_FULL$CHR[1],3]+P_FULL$BP[1] ; X_LIM_MX <- lens[P_FULL$CHR[nrow(P_FULL)],3]+P_FULL$BP[nrow(P_FULL)]
	X_LABEL <- paste("Chromosome",P_FULL$CHR[1])
}
X_LIM <- c(X_LIM_MN,X_LIM_MX)
print(paste("X-Limits are:",paste(X_LIM,collapse="-") ))

jpeg(paste(PathToAssoc, "/",DirName,"_Gene_Manh.jpeg", sep=""), height=2000, width=3400, pointsize=30)
plot(0,0, type="n", xlim=X_LIM, ylim=c(0,Set_Range), xlab=X_LABEL, ylab="-log10(p-value)", main="Association with Individual Variants (MAF>5%)", xaxt="n")
# abline(h=-log10(.1), col="chocolate1", lty=2, lwd=3) ; text(0,-log10(.1)+.1,pos=2,labels="Thrsh",col="chocolate1")
abline(h=-log10(5e-8), col="black", lty=2, lwd=3) ; text(X_LIM_MN,-log10(5e-8)+.1,pos=2,labels="5e-8",col="black")
abline(h=-log10(0.05/N_Vars), col="grey50", lty=2, lwd=3) ; text(X_LIM_MN,-log10(.05/N_Vars)+.1,pos=2,labels="Bonf",col="grey50")
legend(0,9.2, legend=c("Damg","Func","Odd-Chr","Even-Chr"), pch=20, col=c(COLS_2[2:1],COLS_1[1:2]) )
if (P_FULL$CHR[1]==P_FULL$CHR[nrow(P_FULL)]) {
	CHR_MARKS <- seq(lens[P_FULL$CHR[1],3],lens[P_FULL$CHR[1]+1,3],1e7)
	CHR_LABELS <- seq(0,lens[P_FULL$CHR[1],2],1e7)
	abline(v=CHR_MARKS,lty=2,col="grey75")
	axis(1, at=CHR_MARKS, labels=CHR_LABELS, tick=T)
}
for (chrom in 1:24) {
	points( (lens[chrom,3]+P_FULL$BP[which(P_FULL$CHR==chrom)]), -log10(P_FULL$P[which(P_FULL$CHR==chrom)]), col=COLS_1[chrom], pch=20, cex=1 )
	if (P_FUNC!="None") { points( (lens[chrom,3]+P_FUNC$BP[which(P_FUNC$CHR==chrom)]), -log10(P_FUNC$P[which(P_FUNC$CHR==chrom)]), col=COLS_2[1], pch=20, cex=1 ) }
	if (P_DAMG!="None") { points( (lens[chrom,3]+P_DAMG$BP[which(P_DAMG$CHR==chrom)]), -log10(P_DAMG$P[which(P_DAMG$CHR==chrom)]), col=COLS_2[2], pch=20, cex=1 ) }
#	text(mean(lens[chrom:(chrom+1),3]), 2.4, labels=lens[chrom,1], col="black") 
	arrows(lens[chrom,3], -1, lens[chrom,3], 0, col="black", length=0, lwd=3 )
}
if (P_FULL$CHR[1]!=P_FULL$CHR[nrow(P_FULL)]) { axis(1, at=apply(data.frame(lens$ADD[1:23],lens$ADD[2:24]),1,mean), labels=lens[1:23,1], tick=F) }
#arrows(lens[23,3], 1.5, lens[23,3], 2, col="black", length=0, lwd=3)
for (gene in 1:length(FULL)) {
	X_Coord <- mean(FULL[[gene]]$BP) + lens$ADD[FULL[[gene]]$CHR[1]]
	text(X_Coord,-log10(BEST_P[gene])+.5, labels=names(FULL)[gene], srt=90, col="black" )
}
dev.off()
print("Skyline DONE!")

## Make Q-Q Plot
print("Time for QQ-Plot")
X_MAX <- ceiling( -log10(1/nrow(P_FULL)) )
Y_MAX <- ceiling( -log10(min(P_FULL$P,na.rm=T)) )
MAX <- max(X_MAX,Y_MAX)
COLS <- c("chartreuse","goldenrod1","firebrick1")
P_ALL <- list(P_FULL,P_FUNC,P_DAMG) #c("firebrick2","chocolate2","gold2","chartreuse2","dodgerblue2","darkorchid2")
jpeg(paste(PathToAssoc, "/",DirName,"_Gene_QQ.jpeg", sep=""), height=1500, width=1500, pointsize=30)
plot(0,0,type="n",xlim=c(0,MAX),ylim=c(0,MAX),xlab="Expected",ylab="Observed",main="Q-Q for Subsets of Gene Variants")
abline(0,1,lty=2,lwd=2,col="grey50")
for (i in 1:3) {
	if (P_ALL[[i]]!="None") {
		DATA <- P_ALL[[i]]
		if ( length(which(!is.na(DATA$P))) > 0 ) {
			OBS <- sort(DATA$P)
			EXP <- 1:length(OBS)/length(OBS)
			points(-log10(EXP),-log10(OBS),col=COLS[i],pch="+")
		}
	}
}
legend(0.7*MAX,0.3*MAX,legend=c("Full","Func","Damg"),pch="+",col=COLS)
dev.off()
print("QQ-Plot Finished.......closing up shop...")

###############################################################
###########    END OF DOC    ##################################
###############################################################














