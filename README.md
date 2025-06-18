How To Use Code (Displacement)
1.	Prepare Your Images
o	The images extracted from a recorded test video using a separate MATLAB code (Video).
o	These extracted images should capture the motion you want to track frame by frame.
2.	Name the Images Properly
o	Make sure the extracted images are saved with names following the pattern:
Displacement_0.jpg, Displacement_1.jpg, Displacement_2.jpg, and so on.
o	The order of the images is extremely important because the point tracking depends on sequential filenames to work correctly.
3.	Set the Folder Path
o	In the code, update the imageDir variable with the path to the folder containing your extracted images.
4.	Ensure the First Image Exists
o	Check that Displacement_0.jpg is present inside the folder.
o	If not found, the code will give an error and stop.
5.	Run the Code in MATLAB
6.	Select the Point to Track
o	The first image (Displacement_0.jpg) will open.
o	You can zoom in/out to choose carefully.
o	After closing the popup message, click on the point you want to track.
7.	Select Two Points for Reference Distance
o	The same first image will appear again.
o	You need to select two points between which you know the real-world distance (for example, any circle diameter is 30 mm).
8.	Enter the Known Distance
o	After selecting the two points, a prompt will ask you to enter the actual distance between them (in millimeters).
 
9.	Automatic Tracking
o	The program will track the selected point through all sequential images automatically.
o	If tracking fails in any image, a warning will appear.
10.	View and Save the Results
o	The code will calculate:
	X and Y displacements (in millimeters).
	Total displacement (in millimeters).
o	Results will be saved into three CSV files:
	trackedPointsMm.csv (tracked points in mm)
	displacementXY.csv (X and Y displacements)
	displacementTotal.csv (total displacement)

