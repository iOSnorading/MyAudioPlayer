//
//  ViewController.m
//  MyAudioPlayer
//
//  Created by norading on 16/7/5.
//  Copyright © 2016年 NoraDing. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSTimer *processTimer;
@property (nonatomic, assign) NSInteger tempIndex;
@property (nonatomic, strong) UISlider *volumeSlider;

- (IBAction)showVolume:(id)sender;
- (IBAction)lastSong:(id)sender;
- (IBAction)playSong:(id)sender;
- (IBAction)nextSong:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArr = [NSMutableArray arrayWithArray:@[@"卢西-赤道和北极",@"吴亦凡-时间煮雨",@"严艺丹-三寸天堂"]];

    [self loadMusic];
    
    _processTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(process) userInfo:nil repeats:YES];
    [_progressSlider addTarget:self action:@selector(processSet) forControlEvents:UIControlEventValueChanged];
    
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(-95, 350, 220, 5)];
    _volumeSlider.minimumValue = 0;
    _volumeSlider.maximumValue = 1;
    _volumeSlider.value = 0.5;
    _volumeSlider.hidden  = YES;
    [_volumeSlider addTarget:self action:@selector(volumeSet) forControlEvents:UIControlEventValueChanged];
    _volumeSlider.transform = CGAffineTransformMakeRotation(-90*M_PI/180);
    [self.view addSubview:_volumeSlider];
}

- (void)volumeSet {
    
    _audioPlayer.volume = _volumeSlider.value;
}

- (void)loadMusic {
    
    _tempIndex = 0;
    NSString *path = [[NSBundle mainBundle] pathForResource:_nameArr[0] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.delegate = self;
    _audioPlayer.volume = 0.5;
    [_audioPlayer prepareToPlay];
}

- (void)process {
    
    _progressSlider.value = _audioPlayer.currentTime/_audioPlayer.duration * 100;
}

- (void)processSet {
    
    _audioPlayer.currentTime = _progressSlider.value/100 * _audioPlayer.duration;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showVolume:(id)sender {
    
    if (_volumeSlider.hidden) {
        
        _volumeSlider.hidden = NO;
        
    }else {
        
        _volumeSlider.hidden  = YES;
    }
}

- (IBAction)lastSong:(id)sender {
    
    _tempIndex--;
    NSString *path = [[NSBundle mainBundle] pathForResource:_nameArr[_tempIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.volume = _volumeSlider.value;
    [_audioPlayer play];
}

- (IBAction)playSong:(id)sender {
    
    if (_audioPlayer.playing) {
        
        [_audioPlayer pause];
        
    }else{
        
        [_audioPlayer play];
    }
}

- (IBAction)nextSong:(id)sender {
    
    _tempIndex++;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:_nameArr[_tempIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.volume = _volumeSlider.value;
    [_audioPlayer play];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _nameArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _nameArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *songName = _nameArr[indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.volume = _volumeSlider.value;
    [_audioPlayer play];
    
    _tempIndex = indexPath.row;
}

//摇一摇
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        
        //更换下一首
    }
}

@end
