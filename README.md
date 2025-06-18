How To Use Code (Displacement)
1.	Prepare Your Images
•	The images extracted from a recorded test video using a separate MATLAB code (Video).
•	These extracted images should capture the motion you want to track frame by frame.
2.	Name the Images Properly
•	Make sure the extracted images are saved with names following the pattern:
Displacement_0.jpg, Displacement_1.jpg, Displacement_2.jpg, and so on.
•	The order of the images is extremely important because the point tracking depends on sequential filenames to work correctly.
3.	Set the Folder Path
•	In the code, update the imageDir variable with the path to the folder containing your extracted images.
4.	Ensure the First Image Exists
•	Check that Displacement_0.jpg is present inside the folder.
•	If not found, the code will give an error and stop.
5.	Run the Code in MATLAB
6.	Select the Point to Track
•	The first image (Displacement_0.jpg) will open.
•	You can zoom in/out to choose carefully.
•	After closing the popup message, click on the point you want to track.
7.	Select Two Points for Reference Distance
•	The same first image will appear again.
•	You need to select two points between which you know the real-world distance (for example, any circle diameter is 30 mm).
8.	Enter the Known Distance
•	After selecting the two points, a prompt will ask you to enter the actual distance between them (in millimeters).
 
9.	Automatic Tracking
•	The program will track the selected point through all sequential images automatically.
•	If tracking fails in any image, a warning will appear.
10.	View and Save the Results
•	The code will calculate:
	X and Y displacements (in millimeters).
	Total displacement (in millimeters).
•	Results will be saved into three CSV files:
	trackedPointsMm.csv (tracked points in mm)
	displacementXY.csv (X and Y displacements)
	displacementTotal.csv (total displacement)

