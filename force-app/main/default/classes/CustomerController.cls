public class CustomerController {
	public final Customer__c  customerObject {get; set;}
	public List<Customer__c> customers {get; set;}
	public List<Customer__c > customer_record {get; set;}
	public ID customer_id;
	public String actionType;
    
	public CustomerController(Apexpages.StandardController standardcontroller) {       
		this.customer_id = ApexPages.currentPage().getparameters().get('customer_id');
		this.actionType = ApexPages.currentPage().getparameters().get('action');
		
		if(customer_id != null){
			this.customer_record = [SELECT Id, Name, Last_Name__c, Email__c, Phone__c, Street_Address__c, State__c, Zip_Code__c, (SELECT Id, Name, Total_Invoice_Amount__c, start_date__c FROM Invoices__r) FROM Customer__c WHERE Id =: customer_id LIMIT 1];
			this.customerObject = [SELECT Id, Name, Last_Name__c, Email__c, Phone__c, Street_Address__c, State__c, Zip_Code__c, (SELECT Id, Name, Total_Invoice_Amount__c, start_date__c FROM Invoices__r) FROM Customer__c WHERE Id =: customer_id LIMIT 1];
		}else{
			this.customerObject = (Customer__c)standardcontroller.getRecord();
		}

		this.customers = [SELECT Id, Name, Last_Name__c, Email__c, Street_Address__c, State__c, Zip_Code__c, Phone__c FROM Customer__c ];
	}
    
    public PageReference updateCustomer() {
		PageReference customerDetailedPage = new PageReference('/apex/customerDetailed?customer_id=a005f000001MKg5AAG');
		customerDetailedPage.setRedirect(true);
		return customerDetailedPage;
    }
	
	public PageReference deleteCustomer(){
		if(actionType == 'delete' && customer_id != null){
			List<Customer__c> customer = [SELECT Id FROM Customer__c WHERE Id =: customer_id LIMIT 1];

			if(customer.size() == 1){
				delete customer;

				PageReference listCustomersPage = new PageReference('/apex/ListCustomers');
				listCustomersPage.setRedirect(true);
				return listCustomersPage;
			}
		}

		return null;
    }
    
    public PageReference createCustomer() {
        //Get the incoming email address
        String customer_email = customerObject.Email__c;
        
        //Check if a record exists against that customer email
        List<Customer__c> customer = [SELECT Id, Name, Last_Name__c, Email__c, Street_Address__c, State__c, Zip_Code__c, Phone__c FROM Customer__c WHERE Email__c =: customer_email LIMIT 1];
        
		//check if the list size is greater than 0
        if(customer.size() > 0){
            customer[0].Name = customerObject.Name;
            customer[0].Last_Name__c = customerObject.Last_Name__c;
            customer[0].Email__c = customerObject.Email__c;
            customer[0].Street_Address__c = customerObject.Street_Address__c;
            customer[0].State__c = customerObject.State__c;
            customer[0].Zip_Code__c = customerObject.Zip_Code__c;
            customer[0].Phone__c = customerObject.Phone__c;
            upsert customer;
			customer_id = customer[0].Id;
        }else{
            insert customerObject;
			customer_id = customerObject.Id;
        }

        //Redirect User to the customer detailed Page
		PageReference customerDetailedPage = new PageReference('/apex/customerDetailed?customer_id='+customer_id);
		customerDetailedPage.setRedirect(true);
		return customerDetailedPage;
    }
}