import { LightningElement, track} from 'lwc';
import getDataFromReddit from '@salesforce/apex/Call_RedditHPPT_Cls.callReddit'

export default class CallReditApex extends LightningElement {
    @track mensaje;
    @track error;
    handlerCall() {
        getDataFromReddit()
        .then (result => {
            this.mensaje = result;
            console.log(JSON.stringify(this.mensaje));
            window.alert(JSON.stringify(this.mensaje));
        })
        .catch( error => {
            this.error = error;
        })
    }
}