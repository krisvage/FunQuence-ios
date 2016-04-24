mkdir -p Delivery/Patterns
cp Cartfile Cartfile.resolved Delivery/Patterns
cp create_delivery.sh Delivery/Patterns
cp -r Patterns Delivery/Patterns
cp -r PatternsTests Delivery/Patterns
mkdir -p Delivery/Patterns/FunQuence.xcodeproj
cp Funquence.xcodeproj/project.pbxproj Delivery/Patterns/FunQuence.xcodeproj/
mkdir -p Delivery/Patterns/FunQuence.xcodeproj/project.xcworkspace
cp Funquence.xcodeproj/project.xcworkspace/contents.xcworkspacedata Delivery/Patterns/FunQuence.xcodeproj/project.xcworkspace
mkdir -p Delivery/Patterns/Carthage
cd Delivery
zip -r funquence-ios-g12.zip Patterns
cd ..
mv Delivery/funquence-ios-g12.zip .
rm -r Delivery
