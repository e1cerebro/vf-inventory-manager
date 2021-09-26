public class CustomerInvoicesController {
	public final Customer__c  customerObject {get; set;}
    public List<Customer__c> customers {get; set;}
    
    //This runs when the page loads
    public CustomerInvoicesController(Apexpages.StandardController standardcontroller) {
      this.customerObject = (Customer__c)standardcontroller.getRecord();
      String customerId = ApexPages.currentPage().getparameters().get('id');
      this.customers = [SELECT Id, Name, Last_Name__c, (SELECT Id, Name, Total_Invoice_Amount__c, start_date__c   FROM Invoices__r) FROM Customer__c WHERE Id =: customerId ];
    }
}