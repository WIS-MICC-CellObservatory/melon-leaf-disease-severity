///////////////////////////////////////////////////////////////////////////
//This script loop over masked objects files and counts objects within ROIs  
// Written by Dina Mant 
///////////////////////////////////////////////////////////////////////////


/////////////////////////////
// Main script body
////////////////////////////

// Folder and files definitions

//Folder where objects masks are located
input_folder = "C:/Users/saulb-lab/Desktop/try1/"
//Folder where output files will be written
output_folder = "C:/Users/saulb-lab/Desktop/output1/"
suffix = ".tiff"

//Folder where ROI masks are located 
roi_folder="C:/Users/saulb-lab/Desktop/roi/"
//ROI file name
roi_fname="3-MotB+M6.zip"

// USE THESE FOR DEBUG 
//max number of input files - make it easier to debug if want to test just on 1 or 2 files
max_files=1000;
//max_files=1;
//max number of roi per file - make it easier to debug if want to test just a small number of ROIs, say 10
max_rois=100000000;
//max_rois=10;



//0. Reset windows and close any open images
roiManager("reset");
run("Close All");

//loop over all mask files in the input_folder and call the main function, called "processFile", this that counts objects in each ROI
processFolder(input_folder);


/////////////////////////////////
// Function defintions
////////////////////////////////

///////////////////////////////////////////////////////////
//the main function of this script. It loops over all objects masks files in the input folder
///////////////////////////////////////////////////////////
function processFolder(input_folder){
	list = getFileList(input_folder);
	for (j = 0; (j < list.length) && (j < max_files); j++){
		if (File.isDirectory(input_folder + list[j]))
			processFolder("" + input_folder + list[j]);
		if (endsWith(list[j], suffix));
			processFile(input_folder, output_folder, list[j]);
	}
}

///////////////////////////////////////////////////////////
//the core function of this script. It counts object per ROI
///////////////////////////////////////////////////////////
function processFile(input_folder, output_folder, file) {

//1. Loading Nuclear ROIs .zip from roi_folder
run("ROI Manager...");
//showMessage("ROI file selection", "Select ROI.zip file from reference channel (i.e. DAPI)");
//run("Open...");
roiManager("Open", roi_folder + roi_fname);
	
//2. Seletcting object mask file and open it 
//showMessage("Image selection", "Select an image from channel of interest");
//run("Open...");
open(input_folder + file);
//mask file name
curr_fname = file;

//3.Selecting the image window and start processing segmentation images made by ilastik
selectWindow(curr_fname);
run("Duplicate...", "title=" + curr_fname + "copy");

//4. Making image background value lower than particle of interest.
//showMessage("Background value check", "Make sure your background value is lower than foreground!");
//run("Invert");

//5. Making an 8-bit from 32-bit (made by ilastik)
run("glasbey");
run("Enhance Contrast...", "saturated=0.35 normalize");
setAutoThreshold("Default dark");
run("Threshold...");
setThreshold(109, 154);
run("Convert to Mask");


//6.Counting objects inside each roi repeatedly over all ROIs
//showMessage("Adjust particle size in the macro accroding to the image data");
num_of_ROIs = roiManager("count");
for(i=0; i<num_of_ROIs && i<max_rois; i++){
	roiManager("Select", i);
	run("Set Measurements...", "area perimeter display redirect=None decimal=3");
	//run("Analyze Particles...", "size=0-Infinity display include summarize add in_situ");
	run("Analyze Particles...", "clear");
	//run("Analyze Particles...", "display summarize add");
	run("Analyze Particles...", "summarize add");
}

//remove suffix (e.g. ".tif") from fname
curr_fname_wo_suffix = replace(curr_fname, suffix, "");

////7.Saving ROIs to a .zip file
roiManager("save", output_folder + curr_fname_wo_suffix + ".zip")


//8. Saving Results from summary window to a .csv
selectWindow("Summary");

saveAs("Results",  output_folder + curr_fname_wo_suffix + ".csv");
 
//run("Close");
print("Clearing results and resetting ROI Manager");
run("Clear Results");
roiManager("reset");

// uncomment if you want to close all image files 
////close(input_folder + file);
//close("*");
}