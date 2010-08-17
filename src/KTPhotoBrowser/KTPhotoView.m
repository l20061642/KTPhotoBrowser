//
//  KTPhotoView.m
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Completely rewritten by Dave Batton so the image is zoomable.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoView.h"
#import <QuartzCore/QuartzCore.h>

@interface KTPhotoView ()
- (void)photoViewInit;
- (CGRect)centeredFrameForSize:(CGSize)size;
- (void)updateZoomLimits;
- (CGFloat)zoomScaleThatFits;
@end


@implementation KTPhotoView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self photoViewInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder])
        [self photoViewInit];
    return self;
}

- (void)photoViewInit {
    self.delegate = self;
    self.backgroundColor = [UIColor orangeColor];
    
    photoImageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
    photoImageView_.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:photoImageView_];
}

- (void)dealloc {
    [photoImageView_ release], photoImageView_ = nil;
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    photoImageView_.frame = [self centeredFrameForSize:photoImageView_.frame.size];
}

- (void)setImage:(UIImage *)newImage {
    self.zoomScale = 1.0f;
    photoImageView_.image = newImage;
    photoImageView_.frame = CGRectMake(0.0f, 0.0f, photoImageView_.image.size.width, photoImageView_.image.size.height);
    self.contentSize = photoImageView_.image.size;
    [self updateZoomLimits];
    self.zoomScale = MIN([self zoomScaleThatFits], 1.0f);
}

- (CGRect)centeredFrameForSize:(CGSize)size {
    CGFloat boundsWidth = self.bounds.size.width - self.contentInset.left - self.contentInset.right;
    CGFloat boundsHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    CGRect centeredFrame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
        // center horizontally
    if (centeredFrame.size.width < boundsWidth)
        centeredFrame.origin.x = (boundsWidth - centeredFrame.size.width) / 2;
    else
        centeredFrame.origin.x = 0.0f;
    
        // center vertically
    if (centeredFrame.size.height < boundsHeight)
        centeredFrame.origin.y = (boundsHeight - centeredFrame.size.height) / 2;
    else
        centeredFrame.origin.y = 0.0f;
    
    return centeredFrame;
}

- (void)updateZoomLimits {
    CGFloat zoomScale = [self zoomScaleThatFits];
    if (zoomScale <= 1.0f) {
        self.minimumZoomScale = zoomScale;
        self.maximumZoomScale = 2.0f;
    }
    else {
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = MIN(zoomScale, 2.0f);
    }
}

- (CGFloat)zoomScaleThatFits {
        // Returns the zoom scale that shows the entire contents.
    CGFloat hScale = (self.frame.size.width - self.contentInset.left - self.contentInset.right) / photoImageView_.image.size.width;
    CGFloat vScale = (self.frame.size.height - self.contentInset.top - self.contentInset.bottom) / photoImageView_.image.size.height;
	return MIN(hScale, vScale);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return photoImageView_;
}


@end
