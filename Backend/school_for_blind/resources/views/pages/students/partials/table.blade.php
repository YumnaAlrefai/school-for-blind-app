<div class="table-responsive">
 <table class="table table-hover-custom align-middle mb-0" style="color: var(--text-main);">
  <thead>
   <tr style="border-bottom: 2px solid var(--border-color);">
    <th scope="col" class="pb-3 text-muted fw-normal text-end">اسم الطالب</th>
    <th scope="col" class="pb-3 text-muted fw-normal text-end">رقم الهاتف</th>
    <th scope="col" class="pb-3 text-muted fw-normal text-end">المستوى</th>
    <th scope="col" class="pb-3 text-muted fw-normal text-end">الحالة</th>
   </tr>
  </thead>
  <tbody>
   @forelse($students as $student)
    <tr style="border-bottom: 1px solid var(--border-color); cursor: pointer;" data-bs-toggle="modal"
     data-bs-target="#studentModal{{ $student->id }}">
     <td class="py-3 text-end fw-bold">{{ $student->fullname }}</td>
     <td class="py-3 text-end">{{ $student->phone }}</td>
     <td class="py-3 text-end">
      <span class="badge bg-secondary px-2 py-1">{{ $student->level === 'ninth' ? 'التاسع' : 'البكالوريا' }}</span>
     </td>
     <td class="py-3 text-end">
      @php
       $statusColors = ['pending' => 'warning', 'approved' => 'success', 'rejected' => 'danger'];
       $color = $statusColors[$student->status] ?? 'secondary';
      @endphp
      <span class="badge-status bg-soft-{{ $color }} text-{{ $color }} px-2 py-1 rounded">
       {{ $student->status }}
      </span>
     </td>
    </tr>

    @include('pages.students.partials.modal', ['student' => $student])

   @empty
    <tr>
     <td colspan="4" class="text-center py-4 text-muted">لا يوجد طلاب لعرضهم.</td>
    </tr>
   @endforelse
  </tbody>
 </table>
</div>