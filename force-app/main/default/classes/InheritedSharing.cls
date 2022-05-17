public inherited sharing class InheritedSharing {
    public static Integer getAccountSize() {
        return [Select Id from Account].size();
    }
}
