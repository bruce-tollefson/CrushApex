public abstract class TriggerHandler {

    private TriggerOperation opType;
    private String triggerObject;
    private boolean isActive;
    private static Set<String> omitObjectSet = new Set<String>();


    public TriggerHandler() {
        this.opType = Trigger.OperationType;
        this.triggerObject = Trigger.isDelete ? String.ValueOf(Trigger.old.getSObjectType()) : String.ValueOf(Trigger.new.getSObjectType());
        this.isActive = Trigger_Setting__mdt.getInstance(triggerObject)?.isActive__c;
    }

    public void runTrigger(){

        if(stopRun()){
            return;
        }

    switch on Trigger.OperationType {
        when BEFORE_INSERT {
            beforeInsert();
        }
        when BEFORE_UPDATE {
            beforeUpdate();
        }
        when BEFORE_DELETE{
            beforeDelete();
        }
        when AFTER_INSERT{
            afterInsert();
        }
        when AFTER_UPDATE{
            afterUpdate();
        }
        when AFTER_DELETE{
            afterDelete();
        }
        when AFTER_UNDELETE{
            afterUndelete();
        }
    }
    }

    private Boolean stopRun(){
        return (isActive == null || !isActive || omitObjectSet.contains(this.triggerObject)) ? true : false;
    }

    public static void setomitObjectSet(String objectName){
        if(Type.forName(objectName) != null) omitObjectSet.add(objectName); else throw new TriggerHandlerException('Object is not valid');
    }

    public static void removeomitObjectSet(String objectName){
        omitObjectSet.remove(objectName);
    }

    protected abstract void beforeInsert();
    protected abstract void beforeUpdate();
    protected abstract void beforeDelete();
    protected abstract void afterInsert();
    protected abstract void afterUpdate();
    protected abstract void afterDelete();
    protected abstract void afterUndelete();


    public class TriggerHandlerException extends Exception{}
}
