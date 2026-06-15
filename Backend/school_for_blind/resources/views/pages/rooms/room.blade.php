@extends('layouts.app')

@section('content')
 <div class="call-container">
  <h2>غرفة الاجتماع الصوتي</h2>

  <button id="join-btn">انضمام للمكالمة</button>
  <button id="mute-btn" style="display: none;">كتم المايك</button>
  <button id="leave-btn" style="display: none;">خروج من المكالمة</button>

  <h3>المتواجدون الآن:</h3>
  <ul id="participants-list"></ul>
 </div>

 <script src="https://cdn.jsdelivr.net/npm/livekit-client/dist/livekit-client.umd.min.js"></script>

 <script>
  const livekitUrl = '{{ config("livekit.web_url") }}';
  const token = '{{ $token }}';

  const room = new LivekitClient.Room();

  const joinBtn = document.getElementById('join-btn');
  const muteBtn = document.getElementById('mute-btn');
  const leaveBtn = document.getElementById('leave-btn');
  const participantsList = document.getElementById('participants-list');

  joinBtn.onclick = async () => {
   await room.connect(livekitUrl, token);
   await room.localParticipant.setMicrophoneEnabled(true);

   joinBtn.style.display = 'none';
   muteBtn.style.display = 'inline-block';
   leaveBtn.style.display = 'inline-block';
  };

  room.on('trackSubscribed', (track) => {
   if (track.kind === 'audio') {
    const audioElement = track.attach();
    document.body.appendChild(audioElement);
   }
  });

  room.on('participantConnected', (participant) => {
   const li = document.createElement('li');
   li.id = participant.identity; // نعطيه ID لنسهل حذفه لاحقاً
   li.innerText = participant.identity;
   participantsList.appendChild(li);
  });

  room.on('participantDisconnected', (participant) => {
   const li = document.getElementById(participant.identity);
   if (li) li.remove(); // نحذف اسمه من الشاشة
  });
 </script>
@endsection