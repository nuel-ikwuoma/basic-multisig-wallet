import React, { useState } from 'react'

export default function CreateTransfer({createTransfer}) {
    const [transfer, setTransfer] = useState({});

    const onChangeHandler = (e) => {
        const {name, value} = e.target;
        setTransfer({...transfer, [name]: value})
    }
    const submit = (e) => {
        if(!transfer.amount && !transfer.to) return;
        createTransfer(transfer);
        e.preventDefault();
    }
    return (
        <div>
            <form onSubmit={submit}>
                <input 
                    type="number"
                    name="amount"
                    onChange={onChangeHandler}/>
                <input 
                    name="to"
                    onChange={onChangeHandler}/>
                <button>create transfer</button>
            </form>
        </div>
    )
}
