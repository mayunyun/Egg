//
//  MYYMineAccountViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineAccountViewController.h"
#import "RegistReferModel.h"
#import "MYYMineAccountDetailViewController.h"

@interface MYYMineAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView* _bgView;
    RegistReferModel* _usermodel ;
    UIButton* _headerBtn;
}

@property (nonatomic,strong)UITableView* tbView;
@end

@implementation MYYMineAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usermodel = [[RegistReferModel alloc]init];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self custRequest];
}

- (void)creatUI
{
    self.title = @"我的账户";
    _bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _bgView.backgroundColor = BackGorundColor;
    _bgView.contentSize = CGSizeMake(kScreen_Width, 714);
    [self.view addSubview:_bgView];
    [self tbView];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(10, 60+_tbView.bottom, kScreen_Width - 20, 45);
    [nextBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 2;
    nextBtn.backgroundColor = NavBarItemColor;
    [_bgView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 80+45*5) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.showsHorizontalScrollIndicator = NO;
        [_bgView addSubview:_tbView];
    }
    return _tbView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            return 79;
        }else{
            return 44;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    for (UIView* view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSArray* titleArray =@[@"我的头像",@"账户",@"姓名",@"手机号",@"积分",@"密码"];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtn.frame = CGRectMake(kScreen_Width - 30 - 70, 10, 60, 60);
        [_headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString* baseurl = HTImgUrl;
        [_headerBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",baseurl,_usermodel.folder,_usermodel.autoname]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        _headerBtn.backgroundColor = [UIColor orangeColor];
        _headerBtn.layer.masksToBounds = YES;
        _headerBtn.layer.cornerRadius = 30;
        [cell.contentView addSubview:_headerBtn];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1||indexPath.row == 4){
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 30 - 200, 0, 200, 44)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14];
        if (indexPath.row == 1) {
            label.text = [NSString stringWithFormat:@"%@",_usermodel.accountname];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 4){
            label.text = [NSString stringWithFormat:@"%@",_usermodel.score];
        }
        
        label.textColor = GrayTitleColor;
        [cell.contentView addSubview:label];
    
    }else if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 5){
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 30 - 200, 0, 200, 44)];
        if (indexPath.row == 2) {
            label.text = [NSString stringWithFormat:@"%@",_usermodel.name];
        }else if (indexPath.row == 3){
            label.text = [NSString stringWithFormat:@"%@",_usermodel.phone];
        }else if (indexPath.row == 5){
            label.text = [NSString stringWithFormat:@"%@",_usermodel.password];
        }
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = GrayTitleColor;
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MYYMineAccountDetailViewController* vc = [[MYYMineAccountDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    if (!IsEmptyValue(_usermodel.phone)) {
        vc.usermodel = _usermodel;
    }
    if (indexPath.row == 1) {
        vc.controller = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        vc.controller = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        vc.controller = @"3";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        vc.controller = @"4";
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

- (void)custRequest{
/*
 personal?action=getPersonalInfo
 */
    [HTNetWorking postWithUrl:@"personal?action=getPersonalInfo" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"用户信息%@",str);
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_usermodel setValuesForKeysWithDictionary:array[0]];
            [_tbView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}


//退出登录
- (void)nextBtnClick:(UIButton*)sender{
    /*
     mallLogin?action=exiteMallLogin
     */
    [HTNetWorking postWithUrl:@"mallLogin?action=exiteMallLogin" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:IsLogin];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:ACCOUNTNAME];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:PASSWORD];

        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)headerBtnClick:(UIButton*)sender{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //头像
    if (actionSheet.tag == 1001) {
        if (0 == buttonIndex) {
            [self LocalPhoto];
        } else if (1 == buttonIndex) {
            [self takePhoto];
        }
    }
    
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        // DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //修改图片的大小为90*90
        image = [self thumbnailImage:CGSizeMake(90.0, 90.0) withImage:image];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [self requestPortal:data img:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//修改头像大小
- (UIImage*)thumbnailImage:(CGSize)targetSize withImage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width * screenScale;
    CGFloat targetHeight = targetSize.height * screenScale;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPortal:(NSData*)imgData img:(UIImage*)img {
    //NSData 转 Base64
    //    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //        NSLog(@"上传图片的请求imgStr%@",imgStr);
#pragma mark 上传图片的请求
//    [_headerBtn setImage:img forState:UIControlStateNormal];
    
    NSString* baseUrl = [HTServerConfig getHTServerAddr];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",baseUrl,@"personal?action=uploadCustomerImage"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    [HTNetWorking uploadWithImage:img url:urlStr filename:fileName name:@"img" mimeType:@"image/jpeg" parameters:nil progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
        
    } success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"上传头像返回%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [Command customAlert:@"头像上传成功"];
            [self custRequest];
        }
    } fail:^(NSError *error) {
        
    }];
    

}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
