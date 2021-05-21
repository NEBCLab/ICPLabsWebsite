import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as ICPLabsWebsite_idl, canisterId as ICPLabsWebsite_id } from 'dfx-generated/ICPLabsWebsite';

const agent = new HttpAgent();
const ICPLabsWebsite = Actor.createActor(ICPLabsWebsite_idl, { agent, canisterId: ICPLabsWebsite_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await ICPLabsWebsite.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
