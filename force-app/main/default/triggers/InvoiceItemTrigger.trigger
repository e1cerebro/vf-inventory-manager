trigger InvoiceItemTrigger on Invoice_Item__c (after insert, after update, before delete) {
    if (Trigger.isInsert) {
        for(Invoice_Item__c item : Trigger.New){
			//Get the current invoice item cost
			Decimal item_cost = item.Cost__c;
			//Get the invoice ID
			ID invoice_id = item.Invoice__c;
			//Get the Total Invoice Amount using the invoice ID
			List<Invoice__c> invoices = [SELECT Id, Total_Invoice_Amount__c FROM Invoice__c WHERE id =: invoice_id LIMIT 1];

			if(invoices.size() == 1){
				invoices[0].Total_Invoice_Amount__c = item_cost + invoices[0].Total_Invoice_Amount__c;
				upsert invoices;
			}
        }
    }
    
	if (Trigger.isUpdate) {  
		for(Invoice_Item__c item : Trigger.New){
			//Get the updated invoice item cost and the old cost
			Decimal updated_item_cost = item.Cost__c; 
			Decimal old_item_cost = Trigger.Old[0].Cost__c;
			
			//Get the related invoice ID
			ID invoice_id = item.Invoice__c;
			
			//Get the Total Invoice Amount using the invoice ID
			List<Invoice__c> invoices = [SELECT Id, Total_Invoice_Amount__c FROM Invoice__c WHERE id =: invoice_id LIMIT 1];
			
			//If these values exist then we can safely manipulate the cost and upsert
			if(invoices.size() == 1 && old_item_cost != null &&  updated_item_cost != null ){
				//remove the old cost
				invoices[0].Total_Invoice_Amount__c = invoices[0].Total_Invoice_Amount__c - old_item_cost;
				//add the new cost
				invoices[0].Total_Invoice_Amount__c = invoices[0].Total_Invoice_Amount__c + updated_item_cost;
				upsert invoices;
			}
		}
	}

	if (Trigger.isDelete) {  
		for(Invoice_Item__c item : Trigger.old){
			//Get the item cost
			Decimal item_cost = item.Cost__c; 
			
			//Get the related invoice ID
			ID invoice_id = item.Invoice__c;
			
			//Get the Total Invoice Amount using the invoice ID
			List<Invoice__c> invoices = [SELECT Id, Total_Invoice_Amount__c FROM Invoice__c WHERE id =: invoice_id LIMIT 1];
			
			//If these values exist then we can safely manipulate the cost and upsert
			if(invoices.size() == 1 && item_cost != null ){
				//remove the old cost
				invoices[0].Total_Invoice_Amount__c = invoices[0].Total_Invoice_Amount__c - item_cost;
				upsert invoices;
			}
		}
	}
}