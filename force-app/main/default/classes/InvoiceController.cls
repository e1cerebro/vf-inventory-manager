public class InvoiceController {
	public final Invoice__c  invoice {get; set;}
    public List<Invoice__c> my_invoices {get; set;}
	public List<Customer__c > customer_details {get; set;}
    public List<Invoice__c>  all_invoices {get; set;}
    public String invoiceId {get; set;}
    public String actionType {get; set;}
    public String invoice_item_id {get; set;}
    
    //This runs when the page loads
	public InvoiceController(Apexpages.StandardController standardcontroller) {
		this.invoiceId = ApexPages.currentPage().getparameters().get('id');
		this.actionType = ApexPages.currentPage().getparameters().get('action');
		this.invoice_item_id = ApexPages.currentPage().getparameters().get('item_id');

		this.my_invoices = [SELECT Id, Name, Total_Invoice_Amount__c, start_date__c , Due_Date__c , Customer__r.Id, Customer__r.Name, Customer__r.Last_Name__c, Customer__r.Email__c, (SELECT Id, Name, Cost__c, Description__c  FROM Invoice_Items__r) FROM Invoice__c  WHERE Id =: this.invoiceId ];
		this.all_invoices = [SELECT Id, Name, Total_Invoice_Amount__c, start_date__c , Due_Date__c , Customer__r.Id, Customer__r.Name, Customer__r.Last_Name__c FROM Invoice__c ];

		if(invoiceId != null){
			this.invoice = [SELECT Id, Name, Total_Invoice_Amount__c, start_date__c , Due_Date__c , Customer__r.Id, Customer__r.Name, Customer__r.Last_Name__c, Customer__r.Email__c FROM Invoice__c  WHERE Id =: this.invoiceId ];
		}else{
			this.invoice = (Invoice__c)standardcontroller.getRecord();
		}
	}
    
    public PageReference deleteInvoice() {
		if(actionType == 'delete' && invoiceId != null){
			List<Invoice__c> invoice = [SELECT Id FROM Invoice__c WHERE Id =: invoiceId LIMIT 1];

			if(invoice.size() == 1){
				delete invoice;

				PageReference allInvoices = Page.AllInvoices; 
				allInvoices.setRedirect(true);
				return allInvoices;
			}
		}
		return null;		
	}    
	
	public PageReference deleteInvoiceItem() {
		if(actionType == 'delete' && invoice_item_id != null){
			List<Invoice_Item__c> invoice_item = [SELECT Id, Invoice__r.Id FROM Invoice_Item__c WHERE Id =: invoice_item_id LIMIT 1];

			if(invoice_item.size() == 1){
				Id item_id = invoice_item[0].Invoice__r.Id;
				delete invoice_item;

				PageReference invoicesItems = new PageReference('/apex/InvoicesItems?id='+item_id );
				invoicesItems.setRedirect(true);
				return invoicesItems;
			}
		}
		return null;		
	}
	
	public PageReference createInvoice() {
        upsert invoice;
		System.debug('Invoice: '+invoice.Id);
		PageReference allInvoices = Page.AllInvoices; 
		allInvoices.setRedirect(true);
        return allInvoices;
	}
}