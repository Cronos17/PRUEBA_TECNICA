import { LightningElement, track,wire} from 'lwc';
import getDataReddit from '@salesforce/apex/Reddit_Data_Cls.getDataReddit';
import deleteRecord from '@salesforce/apex/Reddit_Data_Cls.deleteRecordRedit';
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
const actions = [
    {label:'Eliminar',name:'eliminar'},
    {label:'Mostrar',name:'mostrar'},
];
const columns= [
    {label: 'Title', fieldName:'Title__c'},
    {label:'Author', fieldName:'Name'},
    {label:'Thumbnail', fieldName:'Thumbnail__c'},
    {label:'Selftext', fieldName: 'Selftext__c'},
    {
        type:'action',
        typeAttributes:{rowActions:actions},
    },
];


export default class ShowDataReddit extends LightningElement {
    @track columns = columns;
    @track error;
    @track listReddit;
    @track actions = actions;
    @track showLoadingSpinner=false;
    refreshTable;
    @wire(getDataReddit) listReddit (result){
        this.refreshTable = result;
        if(result.data){
            this.listReddit = result.data;
        }else if(result.error){
            this.error = result.error;
        }
    }
    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName){
            case 'eliminar':
                this.handlerDelete(row.Id);
                break;
            default:
        }
    }
    handlerDelete(idDelete){
        this.showLoadingSpinner = true;
        deleteRecord({idDelete,idDelete})
        .then( result => {
            this.showLoadingSpinner = false;
            const evnt = new ShowToastEvent({
                title:'Eliminación Exitosa',
                message:'Registro eliminado correctamente',
                variant:'success',
                mode:'dismissible'
            });
            console.log('hola result');
            this.dispatchEvent(evnt);
            return refreshApex(this.refreshTable);
        })
        .catch(error =>{
            this.showLoadingSpinner = false;
            this.error = error;
            console.log(error);
            const evnt = new ShowToastEvent({
                title:'Eliminación No Exitosa',
                message:'Registro  NO eliminado corretamente '+error.detail,
                variant:'error',
                mode:'dismissible'
            });
            console.log('hola error');
            this.dispatchEvent(evnt);
            return refreshApex(this.refreshTable);
        });
    }
}