Re-identification-framework (Matlab)
===========================

The framework is for Re-identification, that can add datasets, generate/test methods and so on.<br>
It can support unsupervised/supervised,SvsS/MvsM methods with matlab parallel tools.<br>
It's easy to add dataset/method to test.<br>
If you wanna help me with this framework, please contact [ME](liqian115@gmail.com "liqian115@gmail.com")!!!<br>I would be very grateful.

Folder Explaination
---------------------------

* \<Methods><br>
	--The method of generating feature & model , will use the scripts in <GenerateFeatures> & <GenerateModels> folder.

* \<GenerateFeatures><br>
	--The feature extraction scripts

* \<GenerateModels><br>
	--The modeling scripts

* \<CrossValidation><br>
	--The cross-validation to test the methods

* \<SharedScripts><br>
	--The common scripts that many methods can share, (eg. 'setDataset.m' 'sp_make_dir.m')

* \<SharedMats><br>
	--The common MATs that other methods may use.(eg. Label_iLIDS.mat cvpridx.mat(SDALF selected label of VIPeR dataset))

* \<Labels><br>
	--Saved each iter labels for framework
* \<Features><br>
	--Saved generated features
* \<Models><br>
	--Saved generated models
* \<Results><br>
	--Saved each iter results for framework

Current Datasets
---------------------------
* `VIPeR`(1264 images of 632 people)
* `i-LIDs`(2008 i-LIDS Multiple-Camera Tracking Scenario (MCTS) dataset)
* `ETHZ`(476 images of 119 people, contains seq 1,2,3)
* ……

* To add datasets, please check these files<br>
> setDataset.m<br>
> get_labels.m (For SvsS)<br>
> get_dyn_labels.m (For MvsM)<br>
> setDDNMasks.m(depends on methods)<br>
> Also check the method files you used.<br>


Current Methods
---------------------------
* `GaLF`(Bingpeng MA, Qian Li and Hong Chang.Gaussian Descriptor based on Local Features for Person Re-identification.)<br>
> Generate Feature&Model -- Methods/getGaLF.m<br>
> Test Method -- CrossValidation/testGaLF.m<br>

* `Histogram with patches`<br>
> Generate Feature&Model -- Methods/getHist.m<br>
> Test Method -- CrossValidation/testHist.m<br>

* ……

* To add methods, please check or add these files<br>
> main.m (call the method)<br>
> getXXXX.m (For generating Features and Models,XXXX is your method's name)<br>
> testXXXX.m (For test Models,XXXX is your method's name)<br>
> All params is passed by 'paramALL' and 'paramMethod' (Please refer other methods)<br>

<br>
<br>
Any questions please contact [ME](liqian115@gmail.com "liqian115@gmail.com").<br>
Thanks for your attention!!





