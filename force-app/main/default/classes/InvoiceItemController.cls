public class InvoiceItemController {
	public Invoice_Item__c  invoice_item {get; set;}
	public String invoice_item_id {get; set;}

    
    //This runs when the page loads
    public InvoiceItemController(Apexpages.StandardController standardcontroller) {
		this.invoice_item = (Invoice_Item__c)standardcontroller.getRecord();
		this.invoice_item_id = ApexPages.currentPage().getparameters().get('id');

		if(invoice_item_id != null){
			this.invoice_item = [SELECT Id, Name, Description__c, Cost__c, Invoice__c FROM Invoice_Item__c WHERE Id =: this.invoice_item_id ];
		}else{
			this.invoice_item = (Invoice_Item__c)standardcontroller.getRecord();
		}
    }
    
    public PageReference createInvoiceItem() {
        upsert invoice_item;
        PageReference singleInvoice = new PageReference('/apex/InvoicesItems?id='+invoice_item.Invoice__c );
		singleInvoice.setRedirect(true);
		return singleInvoice;
    }
}