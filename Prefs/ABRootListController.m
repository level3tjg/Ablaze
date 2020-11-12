#include "ABRootListController.h"
#include <Preferences/PSSpecifier.h>
#include "NSTask.h"

@implementation ABRootListController{
  NSMutableDictionary *_prefs;
}

- (id)init {
  if (self = [super init]) {
    _prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.level3tjg.ablaze.plist"];
  }
  return self;
}

- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
  }
  return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
  return _prefs[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  _prefs[specifier.properties[@"key"]] = value;
  [_prefs writeToFile:@"/var/mobile/Library/Preferences/com.level3tjg.ablaze.plist" atomically:YES];
  _prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.level3tjg.ablaze.plist"];
}

- (void)_returnKeyPressed:(id)notification {
  [self.view endEditing:YES];
  [super _returnKeyPressed:notification];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
  self.navigationItem.rightBarButtonItem = respringButton;
}

- (void)respring:(id)arg1 {
  NSTask *task = [NSTask new];
  task.launchPath = @"/bin/bash";
  task.arguments = @[@"-c", @"sbreload"];
  [task launch];
}

@end