All the Mask Type should be coded like this:

function [mask,body_parts,feature_parts]=get_mask(maskmap[,orientation][,I])

Input:
    maskmap
          --- the mask [M * N] 
               (eg. In DDN:
                        "Background" = 0,
                        "Hair" = 10,
                        "Face" = 20,
                        "UpperClothes" = 30,
                        "LowerClothes" = 40,
                        "LeftArm" = 51,
                        "LeftLeg" = 61,
                        "LeftShoes" = 63)
    orientation (optional)
          --- the orentation of each person
    I 
          --- the input image[M * N * 3]

Output:
    mask {body_parts * 1}
          --- a cell of each body part's mask
    body_parts
          --- the whole img seperated into body_parts part
    feature_parts
          --- label each parts , the same feature_part will be calculate together in distance step.