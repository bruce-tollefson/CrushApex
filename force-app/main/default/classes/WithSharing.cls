public with sharing class WithSharing {
    public static Integer getAccountSize() {
        return [Select Id from Account].size();
    }

    public static Integer callInheritedSharing(){
        return InheritedSharing.getAccountSize();
    }
}
